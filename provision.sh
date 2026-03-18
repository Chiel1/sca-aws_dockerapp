#!/bin/bash

set -e

echo "Starting provisioning..."

# Update system packages
echo "Updating system..."
sudo apt update -y
sudo apt upgrade -y

# Install Docker
if ! command -v docker &> /dev/null
then
    echo "Installing Docker..."
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
else
    echo "Docker already installed"
fi

# Install Docker Compose
if ! command -v docker-compose &> /dev/null
then
    echo "Installing Docker Compose..."
    sudo apt install -y docker-compose
else
    echo "Docker Compose already installed"
fi

# Create application directories
echo "Creating project directories..."

mkdir -p ~/wordpress-project
mkdir -p ~/wordpress-project/db-data
mkdir -p ~/wordpress-project/html

echo "Provisioning complete!"

