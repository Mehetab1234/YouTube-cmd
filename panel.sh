#!/bin/bash
# Fancy HydraPanel Installer Script
# This script installs Node.js 20.x, Git, and sets up HydraPanel with colorful output.

# Define color variables for fancy output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Display an ASCII banner
echo -e "${BLUE}"
echo "=========================================="
echo "          HYDRAPANEL INSTALLER"
echo "         by craftingcrazegamimg"  
echo "=========================================="
echo -e "${NC}"

# Step 1: Update system packages
echo -e "${YELLOW}Updating system packages...${NC}"
sudo apt update -y

# Step 2: Install prerequisites: curl, gnupg, and git
echo -e "${YELLOW}Installing curl, gnupg, and git...${NC}"
sudo apt install -y curl gnupg git

# Step 3: Create APT keyrings directory
echo -e "${YELLOW}Creating APT keyrings directory...${NC}"
sudo mkdir -p /etc/apt/keyrings

# Step 4: Add NodeSource GPG key
echo -e "${YELLOW}Adding NodeSource GPG Key...${NC}"
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

# Step 5: Add Node.js 20.x Repository
echo -e "${YELLOW}Adding Node.js 20.x repository...${NC}"
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

# Step 6: Update APT repositories
echo -e "${YELLOW}Updating APT repositories...${NC}"
sudo apt update -y

# Step 7: Install Node.js (Git already installed)
echo -e "${YELLOW}Installing Node.js...${NC}"
sudo apt install -y nodejs

echo -e "${GREEN}Node.js installation complete!${NC}"

# Step 8: Clone HydraPanel Repository
echo -e "${YELLOW}Cloning HydraPanel repository...${NC}"
git clone https://github.com/zwtx2944/hydrapanel.git
if [ $? -ne 0 ]; then
    echo -e "${RED}Error cloning repository. Exiting.${NC}"
    exit 1
fi

# Step 9: Change to the HydraPanel directory
cd hydrapanel || { echo -e "${RED}Directory not found. Exiting.${NC}"; exit 1; }

# Step 10: Install HydraPanel dependencies
echo -e "${YELLOW}Installing HydraPanel dependencies...${NC}"
npm install

# Step 11: Seed the database
echo -e "${YELLOW}Seeding the database...${NC}"
npm run seed

# Step 12: Create a HydraPanel user
echo -e "${YELLOW}Creating HydraPanel user...${NC}"
npm run createUser

# Step 13: Start the HydraPanel server
echo -e "${GREEN}Starting HydraPanel server...${NC}"
node .
