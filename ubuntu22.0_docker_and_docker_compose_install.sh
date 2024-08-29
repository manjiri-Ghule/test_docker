#!/bin/bash

# Function to check if Docker is installed
is_docker_installed() {
    if command -v docker &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to check if Docker Compose is installed
is_docker_compose_installed() {
    if command -v docker-compose &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Update the apt package index and install packages to allow apt to use a repository over HTTPS
sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Use the following command to set up the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Check if Docker is installed
if is_docker_installed; then
    echo "Docker is already installed. Skipping Docker installation."
else
    echo "Docker is not installed. Installing Docker..."
    
    # Update the apt package index again and install Docker
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # Verify that Docker Engine is installed correctly by running the hello-world image
    sudo docker run hello-world
fi

# Check if Docker Compose is installed
if is_docker_compose_installed; then
    echo "Docker Compose is already installed."
else
    echo "Docker Compose is not installed. Installing Docker Compose..."
    
    # Install Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    
    # Apply executable permissions to the binary
    sudo chmod +x /usr/local/bin/docker-compose
    
    # Verify installation
    docker-compose --version
    
    echo "Docker Compose installation completed."
