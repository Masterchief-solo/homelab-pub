#!/bin/bash

# Tell bash to stop the script if any command fails
set -e

# Function to show error messages in red and exit
function error {
    echo -e "\\e[91m$1\\e[39m"
    exit 1
}

# Function to check internet connection before starting
function check_internet() {
    printf "Checking if you are online..."
    # Try to connect to github.com, timeout after 10 seconds
    if timeout 10 wget -q --spider http://github.com; then
        echo "Online. Continuing."
    else
        error "You are offline. Connect to the internet then run the script again."
    fi
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    error "Docker is not installed. Please install Docker first."
fi

# Run the internet check
check_internet

# Pull the latest Portainer image from Docker Hub
sudo docker pull portainer/portainer-ce:latest || error "Failed to pull latest Portainer docker image!"

# Start Portainer container with:
# -d            : Run in background
# -p            : Map ports 9000 and 9443 for web access
# --name        : Name the container 'portainer'
# --restart     : Always restart container if it stops
# -v            : Mount Docker socket and data volume
sudo docker run -d \
    -p 9443:9443 \
    --name=portainer \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:latest || error "Failed to run Portainer docker image!"

# Show success message and instructions
echo -e "\\e[92mPortainer installed successfully!\\e[39m"
echo "You can access Portainer at:"
echo "https://localhost:9443"
