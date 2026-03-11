# Split Tunnel Test Addon - Quick Start Guide

## What This Addon Does

This addon tests your Panabit routing configuration by checking which IP addresses are used when accessing different test endpoints. It's based on the concept from https://ip.skk.moe/split-tunnel.

### Use Cases

1. **Verify Split Tunneling**: Check if different traffic flows use different outbound paths
2. **Test VPN Routing**: Confirm VPN routing policies are working correctly  
3. **Debug Multi-WAN**: Verify which WAN connection is used for different traffic
4. **Monitor NAT**: Check NAT proxy assignments
5. **Network Diagnostics**: Identify routing issues and asymmetrical paths

## Installation

```bash
# Copy to Panabit
sudo cp -r ~/addons/split_tunnel /usr/panabit/app/

# Set permissions
sudo chmod -R 755 /usr/panabit/app/split_tunnel
sudo chmod +x /usr/panabit/app/split_tunnel/appctrl
sudo chmod +x /usr/panabit/app/split_tunnel/web/cgi/*
sudo chmod +x /usr/panabit/app/split_tunnel/bin/*

# Start the addon
sudo /usr/panabit/app/split_tunnel/appctrl start
```

## Quick Test (Command Line)

```bash
/usr/panabit/app/split_tunnel/bin/quick_test.sh
```

## Web Interface

1. Open: `https://<your-panabit-ip>/`
2. Navigate to: **App** → **Split Tunnel** (分流测试)
3. Click: **Start Test**

## Understanding Results

### All Same IP (Green)
```
✓ All requests used the same IP address (1.2.3.4)
```
- No split tunneling detected
- All traffic uses single outbound path

### Different IPs (Yellow)
```
⚠️ Detected 3 different IP addresses - Split tunneling may be active
```
- Split tunneling is working
- Different paths for different endpoints
- Check if this matches your configuration

## Test Endpoints

The addon tests these endpoints (configurable):
- 0.ip.skk.moe
- 1.ip.skk.moe
- 2.ip.skk.moe
- ... (up to 9.ip.skk.moe)

Each endpoint should return the IP address used to access it.

## Advanced Features

### Check System Routing
Shows:
- Default gateway
- Default interface
- NAT proxies
- Routing policies

### Test DNS Resolution
Tests resolution of:
- chatgpt.com
- claude.ai
- discord.com
- etc.

### View Local IPs
Displays all interface IP addresses

## Configuration

Edit `/usr/panabit/app/split_tunnel/conf/splitunnel.conf`:

```bash
# Change test endpoints
PRIMARY_ENDPOINTS="0.ip.skk.moe 1.ip.skk.moe ..."

# Adjust timeouts
TEST_TIMEOUT=5

# Enable logging
LOG_ENABLED=1
```

## Troubleshooting

### Addon not visible in UI
```bash
# Check deployment
ls /usr/ramdisk/admin/cgi-bin/App/split_tunnel/

# Restart
/usr/panabit/app/split_tunnel/appctrl stop
/usr/panabit/app/split_tunnel/appctrl start
```

### Tests timeout
- Check internet connectivity
- Verify firewall allows HTTPS outbound
- Increase timeout in config

### Permission errors
```bash
chmod -R 755 /usr/panabit/app/split_tunnel
chmod +x /usr/panabit/app/split_tunnel/web/cgi/*
```

## Files Created

```
~/addons/split_tunnel/
├── app.inf              # Addon metadata
├── appctrl              # Control script (start/stop)
├── install.sh           # Installation script
├── uninstall.sh         # Uninstallation script
├── README.md            # Full documentation
│
├── bin/
│   └── quick_test.sh    # Command-line tester
│
├── conf/
│   └── splitunnel.conf  # Configuration
│
├── lib/
│   └── helper.sh        # Helper functions
│
└── web/
    ├── cgi/
    │   ├── webmain              # Main page
    │   └── ajax_splitunnel      # API handler
    └── html/
        ├── css/style.css        # Styles
        └── js/splitunnel.js     # JavaScript
```

## Uninstallation

```bash
sudo /usr/panabit/app/split_tunnel/appctrl stop
sudo rm -rf /usr/panabit/app/split_tunnel
sudo rm -rf /usr/ramdisk/admin/cgi-bin/App/split_tunnel
sudo rm -rf /usr/ramdisk/admin/html/App/split_tunnel
```

## Support

- Full docs: `/root/addons/split_tunnel/README.md`
- Logs: `/usr/panabit/data/split_tunnel/test.log`
- Panabit docs: `/root/ADDON.md`, `/root/FLOWEYE.md`
