# How to Install the Split Tunnel Test Addon

## Installation Methods

There are **3 ways** to install this addon:

---

## Method 1: Web UI Upload (Recommended - Easiest)

### Step 1: Create Installation Package
```bash
cd ~/addons
tar -czf split_tunnel.tar.gz split_tunnel/
```

This creates a **16KB tar.gz file** containing the addon.

### Step 2: Upload via Panabit Web UI

1. **Login** to Panabit web interface: `https://<panabit-ip>/`
2. Navigate to: **System** → **App Store** (应用商店)
3. Click **Upload App** or **Manual Install** button
4. **Browse** and select: `split_tunnel.tar.gz`
5. Click **Upload** or **Install**
6. Wait for confirmation message
7. **Done!** The addon appears in **App** menu

### How It Works

Panabit's `ajax_app_store` script:
1. Uploads the tar.gz file
2. Verifies it contains `app.inf` and `appctrl`
3. Extracts to `/usr/panabit/app/split_tunnel/`
4. Runs `appctrl start` automatically
5. Deploys web files to `/usr/ramdisk/admin/cgi-bin/App/split_tunnel/`

### Requirements for Upload

✅ **Package must contain:**
- `app.inf` - Addon metadata file
- `appctrl` - Executable control script
- Valid app_id, app_name, app_cname in app.inf

✅ **Package structure:**
```
split_tunnel.tar.gz
└── split_tunnel/
    ├── app.inf
    ├── appctrl
    ├── web/cgi/
    └── ...
```

---

## Method 2: Manual Command Line Installation

### Step 1: Copy Files
```bash
# Copy addon to Panabit app directory
sudo cp -r ~/addons/split_tunnel /usr/panabit/app/
```

### Step 2: Set Permissions
```bash
# Set directory permissions
sudo chmod -R 755 /usr/panabit/app/split_tunnel

# Make scripts executable
sudo chmod +x /usr/panabit/app/split_tunnel/appctrl
sudo chmod +x /usr/panabit/app/split_tunnel/web/cgi/*
sudo chmod +x /usr/panabit/app/split_tunnel/bin/*
```

### Step 3: Start the Addon
```bash
# Start the addon (deploys web files)
sudo /usr/panabit/app/split_tunnel/appctrl start
```

### Step 4: Enable the Addon
```bash
sudo /usr/panabit/app/split_tunnel/appctrl enable
```

### Step 5: Verify Installation
```bash
# Check if addon is deployed
ls -la /usr/ramdisk/admin/cgi-bin/App/split_tunnel/

# Check addon status
sudo /usr/panabit/app/split_tunnel/appctrl status
```

### Step 6: Access Web Interface
1. Open browser: `https://<panabit-ip>/`
2. Navigate to: **App** menu
3. Click: **Split Tunnel** (分流测试)

---

## Method 3: Using the Install Script

### Quick Install
```bash
cd ~/addons/split_tunnel
sudo ./install.sh
```

The install script automatically:
- ✅ Checks for root permissions
- ✅ Verifies Panabit installation
- ✅ Copies files to `/usr/panabit/app/split_tunnel/`
- ✅ Sets all permissions
- ✅ Starts and enables the addon
- ✅ Creates data directory
- ✅ Deploys web interface

---

## Uninstallation

### Method 1: Via Web UI
1. Login to Panabit web interface
2. Go to: **System** → **App Store**
3. Find **Split Tunnel** in the list
4. Click **Delete** or **Uninstall**

### Method 2: Via Command Line
```bash
# Stop the addon
sudo /usr/panabit/app/split_tunnel/appctrl stop

# Remove addon files
sudo rm -rf /usr/panabit/app/split_tunnel

# Remove web files
sudo rm -rf /usr/ramdisk/admin/cgi-bin/App/split_tunnel
sudo rm -rf /usr/ramdisk/admin/html/App/split_tunnel

# Remove runtime files
sudo rm -rf /usr/ramdisk/app/split_tunnel
```

### Method 3: Using Uninstall Script
```bash
cd ~/addons/split_tunnel
sudo ./uninstall.sh
```

---

## Creating the Installation Package

### From Command Line

```bash
# Navigate to addons directory
cd ~/addons

# Create tar.gz package
tar -czf split_tunnel.tar.gz split_tunnel/

# Verify contents
tar -tzf split_tunnel.tar.gz
```

Expected output:
```
split_tunnel/
split_tunnel/app.inf
split_tunnel/appctrl
split_tunnel/README.md
split_tunnel/web/
split_tunnel/web/cgi/
split_tunnel/web/cgi/webmain
split_tunnel/web/cgi/ajax_splitunnel
split_tunnel/web/html/
split_tunnel/web/html/css/
split_tunnel/web/html/css/style.css
split_tunnel/web/html/js/
split_tunnel/web/html/js/splitunnel.js
...
```

### Package Size
- **Compressed**: ~16KB (tar.gz)
- **Uncompressed**: ~64KB

---

## Installation Verification

### Check Addon Files
```bash
ls -la /usr/panabit/app/split_tunnel/
```

Expected files:
- ✅ app.inf
- ✅ appctrl (executable)
- ✅ web/cgi/webmain
- ✅ web/cgi/ajax_splitunnel
- ✅ web/html/css/style.css
- ✅ web/html/js/splitunnel.js

### Check Web Deployment
```bash
ls -la /usr/ramdisk/admin/cgi-bin/App/split_tunnel/
```

Expected files:
- ✅ webmain
- ✅ ajax_splitunnel

### Test Command Line Tool
```bash
/usr/panabit/app/split_tunnel/bin/quick_test.sh
```

### Test Web Interface
Open: `https://<panabit-ip>/`
Navigate to: **App** → **Split Tunnel**

---

## Troubleshooting Installation

### Addon Not Visible in Web UI

**Check deployment:**
```bash
ls -la /usr/ramdisk/admin/cgi-bin/App/split_tunnel/
```

**If empty, manually deploy:**
```bash
sudo /usr/panabit/app/split_tunnel/appctrl stop
sudo /usr/panabit/app/split_tunnel/appctrl start
```

**Check permissions:**
```bash
ls -la /usr/panabit/app/split_tunnel/appctrl
# Should show: -rwxr-xr-x (executable)
```

### Upload Failed in Web UI

**Check package format:**
```bash
tar -tzf split_tunnel.tar.gz | grep -E "(app.inf|appctrl)"
```

Must show both files!

**Check app.inf content:**
```bash
tar -xzf split_tunnel.tar.gz -O split_tunnel/app.inf
```

Must have: app_id, app_name, app_cname

### Permission Denied Errors

```bash
# Fix all permissions
sudo chmod -R 755 /usr/panabit/app/split_tunnel
sudo chmod +x /usr/panabit/app/split_tunnel/appctrl
sudo chmod +x /usr/panabit/app/split_tunnel/web/cgi/*
sudo chmod +x /usr/panabit/app/split_tunnel/bin/*
```

### Web Files Not Deployed

```bash
# Manually deploy web files
sudo mkdir -p /usr/ramdisk/admin/cgi-bin/App/split_tunnel
sudo mkdir -p /usr/ramdisk/admin/html/App/split_tunnel
sudo cp -r /usr/panabit/app/split_tunnel/web/cgi/* /usr/ramdisk/admin/cgi-bin/App/split_tunnel/
sudo cp -r /usr/panabit/app/split_tunnel/web/html/* /usr/ramdisk/admin/html/App/split_tunnel/
```

---

## Quick Reference Commands

```bash
# Install
sudo cp -r ~/addons/split_tunnel /usr/panabit/app/
sudo chmod -R 755 /usr/panabit/app/split_tunnel
sudo chmod +x /usr/panabit/app/split_tunnel/appctrl
sudo chmod +x /usr/panabit/app/split_tunnel/web/cgi/*
sudo /usr/panabit/app/split_tunnel/appctrl start

# Check status
sudo /usr/panabit/app/split_tunnel/appctrl status

# Stop
sudo /usr/panabit/app/split_tunnel/appctrl stop

# Uninstall
sudo /usr/panabit/app/split_tunnel/appctrl stop
sudo rm -rf /usr/panabit/app/split_tunnel
sudo rm -rf /usr/ramdisk/admin/cgi-bin/App/split_tunnel
sudo rm -rf /usr/ramdisk/admin/html/App/split_tunnel
```

---

## Summary

| Method | Difficulty | Best For |
|--------|-----------|----------|
| **Web UI Upload** | ⭐ Easiest | Most users, quick deployment |
| **Install Script** | ⭐⭐ Easy | Command-line users |
| **Manual Install** | ⭐⭐⭐ Medium | Custom deployments, troubleshooting |

**Recommended**: Use **Web UI Upload** for easiest installation!

---

## Package Location

- **Source**: `~/addons/split_tunnel/` (64KB)
- **Package**: `~/addons/split_tunnel.tar.gz` (16KB)
- **Installed**: `/usr/panabit/app/split_tunnel/`
- **Web UI**: `https://<panabit-ip>/` → App → Split Tunnel
