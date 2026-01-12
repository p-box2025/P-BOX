#!/bin/bash

# P-BOX Linux One-Click Installation Script
# https://github.com/p-box2025/P-BOX

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
INSTALL_DIR="/etc/p-box"
DEFAULT_PORT=8383
GITHUB_REPO="p-box2025/P-BOX"
GITHUB_API="https://api.github.com/repos/${GITHUB_REPO}/releases/latest"

echo -e "${CYAN}"
echo "╔════════════════════════════════════════╗"
echo "║     🚀 P-BOX Linux Installer           ║"
echo "╚════════════════════════════════════════╝"
echo -e "${NC}"

# Check root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}❌ Please run as root (sudo)${NC}"
    exit 1
fi

# Detect architecture
detect_arch() {
    local arch=$(uname -m)
    case "$arch" in
        x86_64|amd64)
            echo "amd64"
            ;;
        aarch64|arm64)
            echo "arm64"
            ;;
        *)
            echo ""
            ;;
    esac
}

ARCH=$(detect_arch)
if [ -z "$ARCH" ]; then
    echo -e "${RED}❌ Unsupported architecture: $(uname -m)${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Detected architecture: ${CYAN}${ARCH}${NC}"

# Get latest version
echo -e "${BLUE}📥 Fetching latest version...${NC}"

VERSION=""
if command -v curl &> /dev/null; then
    VERSION=$(curl -s "$GITHUB_API" | grep '"tag_name"' | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/' | head -n 1)
elif command -v wget &> /dev/null; then
    VERSION=$(wget -qO- "$GITHUB_API" | grep '"tag_name"' | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/' | head -n 1)
fi

# Remove 'v' prefix if present
VERSION=${VERSION#v}

if [ -z "$VERSION" ]; then
    echo -e "${RED}❌ Failed to get latest version${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Latest version: ${CYAN}v${VERSION}${NC}"

# Download URL
FILENAME="p-box-${VERSION}-linux-${ARCH}.tar.gz"
DOWNLOAD_URL="https://github.com/${GITHUB_REPO}/releases/download/v${VERSION}/${FILENAME}"
CDN_URL="https://ghfast.top/${DOWNLOAD_URL}"

echo -e "${BLUE}📥 Downloading P-BOX...${NC}"

TEMP_DIR=$(mktemp -d)
TEMP_FILE="${TEMP_DIR}/${FILENAME}"

# Download
download_success=false

# Try CDN
if curl -sL --connect-timeout 15 -o "$TEMP_FILE" "$CDN_URL" 2>/dev/null; then
    if [ -s "$TEMP_FILE" ] && file "$TEMP_FILE" | grep -q "gzip"; then
        echo -e "${GREEN}✓ Downloaded from CDN${NC}"
        download_success=true
    else
        rm -f "$TEMP_FILE"
    fi
fi

# Fallback to GitHub
if [ "$download_success" = false ]; then
    echo -e "${YELLOW}→ CDN failed, trying GitHub...${NC}"
    if curl -sL --connect-timeout 30 -o "$TEMP_FILE" "$DOWNLOAD_URL" 2>/dev/null; then
        if [ -s "$TEMP_FILE" ] && file "$TEMP_FILE" | grep -q "gzip"; then
            echo -e "${GREEN}✓ Downloaded from GitHub${NC}"
            download_success=true
        fi
    fi
fi

if [ "$download_success" = false ]; then
    echo -e "${RED}❌ Download failed${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Kill existing process
pkill -f "${INSTALL_DIR}/p-box" 2>/dev/null || true

# Create install directory
echo -e "${BLUE}📁 Installing to ${INSTALL_DIR}...${NC}"
mkdir -p "$INSTALL_DIR"

# Extract
tar -xzf "$TEMP_FILE" -C "$TEMP_DIR"

# Find extracted directory
EXTRACTED_DIR=$(find "$TEMP_DIR" -maxdepth 1 -type d -name "p-box-*" | head -n 1)
if [ -z "$EXTRACTED_DIR" ]; then
    EXTRACTED_DIR="$TEMP_DIR"
fi

# Copy files
if [ -d "$EXTRACTED_DIR" ] && [ "$(ls -A $EXTRACTED_DIR)" ]; then
    cp -r "$EXTRACTED_DIR"/* "$INSTALL_DIR/"
else
    echo -e "${RED}❌ Extraction failed${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Set permissions
chmod 755 "$INSTALL_DIR/p-box"

# Update config port
if [ -f "$INSTALL_DIR/config.yaml" ]; then
    sed -i "s/port: 8383/port: ${DEFAULT_PORT}/" "$INSTALL_DIR/config.yaml"
    echo -e "${GREEN}✓ Updated default port to ${DEFAULT_PORT}${NC}"
fi

# Cleanup
rm -rf "$TEMP_DIR"
echo -e "${GREEN}✓ Installation complete${NC}"

# Start P-BOX
echo -e "${BLUE}🚀 Starting P-BOX...${NC}"
cd "$INSTALL_DIR"
nohup ./p-box > /dev/null 2>&1 &

sleep 2

# Check if running
if pgrep -f "${INSTALL_DIR}/p-box" > /dev/null; then
    echo -e "${GREEN}✓ P-BOX is running${NC}"
else
    echo -e "${YELLOW}⚠️ P-BOX may need manual start: cd ${INSTALL_DIR} && ./p-box${NC}"
fi

# Get IP
IP_ADDR=$(hostname -I | awk '{print $1}' 2>/dev/null || echo "localhost")

echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║         ✅ P-BOX Installation Complete!                ║${NC}"
echo -e "${CYAN}╠════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC}                                                        ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  📂 Install Path: ${GREEN}${INSTALL_DIR}${NC}                         ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  🌐 Web Panel: ${GREEN}http://${IP_ADDR}:${DEFAULT_PORT}${NC}              ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}                                                        ${CYAN}║${NC}"
echo -e "${CYAN}╠════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC}  ${YELLOW}💡 开机自启动设置方法：${NC}                               ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}     访问 Web 面板 → 设置 → 系统设置                   ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}     打开「开机自动启动」开关即可                       ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}                                                        ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${YELLOW}💡 Auto-start configuration:${NC}                         ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}     Web Panel → Settings → System Settings            ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}     Enable \"Auto Start on Boot\" switch                ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
