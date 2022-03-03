#!/bin/bash
# This script adds the ansible user.
clear

# Must have sudo access
if [ "$(id -u)" != "0" ]; then
    echo "Please use sudo to run this script." 2>&1
    exit 1
fi


# Check if ansible user already exists
if id -u ansible > /dev/null 2>&1
then
    echo 'ansible user already exists'
    echo ''
else
    echo 'creating ansible user'
    echo ''
    sudo useradd -s /bin/bash -mU ansible
    sudo bash -c 'passwd -Sa | grep -Po "ansible" | sed "s/$/:!CIRT@nsible#/" | chpasswd'
fi


# Adding ansible to sudoers
if grep -Fxq 'ansible ALL=(ALL:ALL) NOPASSWD:ALL' /etc/sudoers.d/ansible
then
    echo 'ansible user already in sudoers'
    echo ''
else
    echo 'adding ansible user to sudoers'
    echo ''
    sudo touch /etc/sudoers.d/ansible
    echo 'ansible ALL=(ALL:ALL) NOPASSWD:ALL' | tee -a /etc/sudoers.d/ansible > /dev/null 2>&1
fi
