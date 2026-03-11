#!/bin/bash

# Split Tunnel Test Addon Installation Script
# This script installs the addon to the Panabit system

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANABIT_ROOT="/usr/panabit"
PANABIT_APP="${PANABIT_ROOT}/app"
ADDON_NAME="split_tunnel"
ADDON_DIR="${PANABIT_APP}/${ADDON_NAME}"

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}Split Tunnel Test Addon Installer${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: Please run as root${NC}"
    exit 1
fi

# Check if Panabit is installed
if [ ! -d "${PANABIT_ROOT}" ]; then
    echo -e "${RED}Error: Panabit installation not found at ${PANABIT_ROOT}${NC}"
    exit 1
fi

# Create app directory if needed
echo -e "${YELLOW}Creating directories...${NC}"
mkdir -p "${PANABIT_APP}"

# Copy addon files
echo -e "${YELLOW}Copying addon files...${NC}"
cp -r "${SCRIPT_DIR}" "${ADDON_DIR}"

# Set permissions
echo -e "${YELLOW}Setting permissions...${NC}"
chmod -R 755 "${ADDON_DIR}"
chmod +x "${ADDON_DIR}/appctrl"
chmod +x "${ADDON_DIR}/web/cgi/"*
chmod +x "${ADDON_DIR}/bin/"*
chmod +x "${ADDON_DIR}/lib/"*

# Create data directory
mkdir -p "${PANABIT_ROOT}/data/${ADDON_NAME}"

# Verify installation
echo -e "${YELLOW}Verifying installation...${NC}"
if [ -f "${ADDON_DIR}/app.inf" ] && [ -x "${ADDON_DIR}/appctrl" ]; then
    echo -e "${GREEN}✓ Addon files installed successfully${NC}"
else
    echo -e "${RED}✗ Installation failed${NC}"
    exit 1
fi

# Start the addon
echo -e "${YELLOW}Starting addon...${NC}"
"${ADDON_DIR}/appctrl" start

# Enable the addon
echo -e "${YELLOW}Enabling addon...${NC}"
"${ADDON_DIR}/appctrl" enable

# Check if web files are deployed
sleep 1
if [ -d "/usr/ramdisk/admin/cgi-bin/App/${ADDON_NAME}" ]; then
    echo -e "${GREEN}✓ Web interface deployed${NC}"
else
    echo -e "${YELLOW}⚠ Web interface not yet deployed${NC}"
    echo -e "${YELLOW}  You may need to restart the web server or wait a moment${NC}"
fi

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}Installation Complete!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo -e "${GREEN}Addon has been installed to:${NC}"
echo -e "  ${ADDON_DIR}"
echo ""
echo -e "${GREEN}Access the web interface at:${NC}"
echo -e "  https://<panabit-ip>/ (Navigate to App → Split Tunnel)"
echo ""
echo -e "${GREEN}Command-line tool:${NC}"
echo -e "  ${ADDON_DIR}/bin/quick_test.sh"
echo ""
echo -e "${GREEN}Configuration file:${NC}"
echo -e "  ${ADDON_DIR}/conf/splitunnel.conf"
echo ""
echo -e "${GREEN}Log file:${NC}"
echo -e "  ${PANABIT_ROOT}/data/${ADDON_NAME}/test.log"
echo ""
echo -e "${YELLOW}To uninstall:${NC}"
echo -e "  ${ADDON_DIR}/appctrl stop"
echo -e "  rm -rf ${ADDON_DIR}"
echo -e "  rm -rf /usr/ramdisk/admin/cgi-bin/App/${ADDON_NAME}"
echo -e "  rm -rf /usr/ramdisk/admin/html/App/${ADDON_NAME}"
echo ""
