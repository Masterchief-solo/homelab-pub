#!/bin/bash

# Stop the script if any command fails
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
        error "You are offline. Connect to the internet and then run the script again."
    fi
}

# Run the internet check
check_internet

# Download and run the official Docker installation script
# -fsSL flags: fail on error, silent mode, show error messages, follow redirects
curl -fsSL https://get.docker.com | sh || error "Failed to install Docker."

# Add your user to the docker group so you can run Docker without sudo
sudo usermod -aG docker $USER || error "Failed to add user to the Docker usergroup."

# Remind user they need to log out and back in
echo "You need to logoff/reboot for the changes to take effect."
