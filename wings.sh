#!/bin/bash
# Fancy HydraLabs Daemon Installer
# This script installs Node.js, Git, and sets up the HydraLabs Daemon.

# Define colors for fancy output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Display an ASCII banner
echo -e "${BLUE}"
echo "=========================================="
echo "        HYDRALABS DAEMON INSTALLER"
echo "=========================================="
echo -e "${NC}"

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}This script must be run as root! Use 'sudo ./script.sh'${NC}"
    exit 1
fi

# Step 1: Update System Packages
echo -e "${YELLOW}Updating system packages...${NC}"
apt update -y && apt upgrade -y || { echo -e "${RED}Failed to update packages!${NC}"; exit 1; }

# Step 2: Install Required Packages
echo -e "${YELLOW}Checking and installing required packages...${NC}"

# Install Git if not installed
if ! command -v git &>/dev/null; then
    echo -e "${YELLOW}Installing Git...${NC}"
    apt install -y git || { echo -e "${RED}Failed to install Git!${NC}"; exit 1; }
else
    echo -e "${GREEN}Git is already installed!${NC}"
fi

# Install Curl (needed for Node.js setup)
if ! command -v curl &>/dev/null; then
    echo -e "${YELLOW}Installing Curl...${NC}"
    apt install -y curl || { echo -e "${RED}Failed to install Curl!${NC}"; exit 1; }
fi

# Install Node.js (latest LTS)
echo -e "${YELLOW}Installing Node.js...${NC}"
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt install -y nodejs || { echo -e "${RED}Failed to install Node.js!${NC}"; exit 1; }

# Step 3: Clone HydraLabs Daemon Repository
if [ -d "daemon" ]; then
    echo -e "${YELLOW}Daemon directory already exists. Skipping cloning...${NC}"
else
    echo -e "${YELLOW}Cloning HydraLabs Daemon repository...${NC}"
    git clone https://github.com/HydraLabs-beta/daemon.git || { echo -e "${RED}Failed to clone repository!${NC}"; exit 1; }
fi

# Step 4: Navigate to Daemon Directory
cd daemon || { echo -e "${RED}Daemon directory not found!${NC}"; exit 1; }

# Step 5: Install Dependencies
echo -e "${YELLOW}Installing dependencies...${NC}"
npm install || { echo -e "${RED}Failed to install dependencies!${NC}"; exit 1; }

# Completion Message
echo -e "${GREEN}HydraLabs Daemon setup complete!${NC}"
