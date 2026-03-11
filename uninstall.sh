#!/bin/bash

# Split Tunnel Test Addon Uninstallation Script
# This script removes the addon from the Panabit system

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Directories
PANABIT_ROOT="/usr/panabit"
PANABIT_APP="${PANABIT_ROOT}/app"
ADDON_NAME="split_tunnel"
ADDON_DIR="${PANABIT_APP}/${ADDON_NAME}"

echo -e "${YELLOW}=========================================${NC}"
echo -e "${YELLOW}Split Tunnel Test Addon Uninstaller${NC}"
echo -e "${YELLOW}=========================================${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: Please run as root${NC}"
    exit 1
fi

# Check if addon is installed
if [ ! -d "${ADDON_DIR}" ]; then
    echo -e "${RED}Error: Addon not found at ${ADDON_DIR}${NC}"
    exit 1
fi

# Ask for confirmation
echo -e "${YELLOW}This will remove the Split Tunnel Test addon.${NC}"
echo -e "${YELLOW}Continue? (y/N):${NC} "
read -r response

if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Uninstallation cancelled.${NC}"
    exit 0
fi

# Stop the addon
echo -e "${YELLOW}Stopping addon...${NC}"
if [ -x "${ADDON_DIR}/appctrl" ]; then
    "${ADDON_DIR}/appctrl" stop || true
fi

# Remove web files
echo -e "${YELLOW}Removing web files...${NC}"
rm -rf "/usr/ramdisk/admin/cgi-bin/App/${ADDON_NAME}"
rm -rf "/usr/ramdisk/admin/html/App/${ADDON_NAME}"

# Remove addon directory
echo -e "${YELLOW}Removing addon directory...${NC}"
rm -rf "${ADDON_DIR}"

# Remove data directory (optional)
echo -e "${YELLOW}Remove data directory (${PANABIT_ROOT}/data/${ADDON_NAME})? (y/N):${NC} "
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    rm -rf "${PANABIT_ROOT}/data/${ADDON_NAME}"
    echo -e "${GREEN}✓ Data directory removed${NC}"
fi

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}Uninstallation Complete!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo -e "${GREEN}The Split Tunnel Test addon has been removed.${NC}"
echo ""
