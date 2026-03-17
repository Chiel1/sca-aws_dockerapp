#!/bin/bash

set -e

echo "=============================="
echo "Starting Provisioning"
echo "=============================="

# Update system
echo "Updating packages..."
sudo apt update -y
sudo apt upgrade -y

# Install Docker if not installed
if ! command -v docker &> /dev/null
then
    echo "Installing Docker..."
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ubuntu
else
    echo "Docker already installed"
fi

# Install Docker Compose if not installed
if ! command -v docker-compose &> /dev/null
then
    echo "Installing Docker Compose..."
    sudo apt install -y docker-compose
else
    echo "Docker Compose already installed"
fi

# Install AWS CLI if not installed
if ! command -v aws &> /dev/null
then
    echo "Installing AWS CLI..."
    sudo apt install -y awscli
else
    echo "AWS CLI already installed"
fi

# Mount EBS volume (check if already mounted)
DEVICE="/dev/xvdf"
MOUNT_POINT="/mnt/mysql-data"

if ! mount | grep $MOUNT_POINT > /dev/null
then
    echo "Setting up EBS volume..."

    # Create mount directory
    sudo mkdir -p $MOUNT_POINT

    # Format only if not formatted
    if ! sudo file -s $DEVICE | grep ext4 > /dev/null
    then
        echo "Formatting volume..."
        sudo mkfs -t ext4 $DEVICE
    fi

    # Mount volume
    sudo mount $DEVICE $MOUNT_POINT

    # Persist after reboot
    echo "$DEVICE $MOUNT_POINT ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab

else
    echo "EBS already mounted"
fi

# Set permissions
echo "Setting permissions..."
sudo chown -R ubuntu:ubuntu /mnt/mysql-data

echo "=============================="
echo "Provisioning Complete"
echo "=============================="
