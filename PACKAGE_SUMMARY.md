# Split Tunnel Test Addon - Complete Package

## Package Summary

**Addon Name**: Split Tunnel Test (分流测试)  
**Version**: 1.0  
**Total Files**: 13  
**Total Size**: 64KB  
**Total Lines**: 1694  

## What's Included

### 📋 Documentation
- `README.md` - Full documentation (6.4KB)
- `QUICKSTART.md` - Quick start guide (4KB)

### ⚙️ Core Files
- `app.inf` - Addon metadata
- `appctrl` - Lifecycle control script

### 🔧 Scripts
- `install.sh` - Automated installation
- `uninstall.sh` - Clean uninstallation
- `bin/quick_test.sh` - Command-line testing tool

### 📚 Libraries
- `lib/helper.sh` - Common helper functions

### ⚙️ Configuration
- `conf/splitunnel.conf` - Addon configuration

### 🌐 Web Interface
- `web/cgi/webmain` - Main web interface
- `web/cgi/ajax_splitunnel` - AJAX API handler
- `web/html/css/style.css` - Modern UI styles
- `web/html/js/splitunnel.js` - Frontend logic

## Features

### ✅ Core Features
- **Multi-endpoint Testing**: Tests 10 different IP check endpoints
- **IP Detection**: Shows IP address for each request
- **Geolocation**: Displays country, city, ISP information
- **Split Tunnel Detection**: Automatically detects if different IPs are used

### 🎨 User Interface
- **Modern Design**: Clean, responsive web interface
- **Visual Feedback**: Color-coded results (green/yellow)
- **Real-time Updates**: AJAX-based testing
- **Multi-language**: Supports Chinese and English

### 📊 Diagnostic Features
- **System Routing Info**: Shows gateways, interfaces, NAT proxies
- **DNS Resolution Test**: Tests domain resolution
- **Local IP Display**: Shows all interface IPs
- **Detailed Logging**: Logs all tests for troubleshooting

### 🔌 API Endpoints
- `test` - Test all split tunnel endpoints
- `domains` - Test domain resolution
- `routing` - Get system routing information
- `interfaces` - Get local interface IPs
- `test_single` - Test single endpoint

## Installation

### Quick Install
```bash
cd ~/addons/split_tunnel
sudo ./install.sh
```

### Manual Install
```bash
sudo cp -r ~/addons/split_tunnel /usr/panabit/app/
sudo chmod -R 755 /usr/panabit/app/split_tunnel
sudo chmod +x /usr/panabit/app/split_tunnel/appctrl
sudo chmod +x /usr/panabit/app/split_tunnel/web/cgi/*
sudo /usr/panabit/app/split_tunnel/appctrl start
```

## Usage

### Web Interface
1. Access: `https://<panabit-ip>/`
2. Navigate: **App** → **Split Tunnel**
3. Click: **Start Test**

### Command Line
```bash
/usr/panabit/app/split_tunnel/bin/quick_test.sh
```

## Test Endpoints

Based on https://ip.skk.moe/split-tunnel:
- 0.ip.skk.moe
- 1.ip.skk.moe
- 2.ip.skk.moe
- 3.ip.skk.moe
- 4.ip.skk.moe
- 5.ip.skk.moe
- 6.ip.skk.moe
- 7.ip.skk.moe
- 8.ip.skk.moe
- 9.ip.skk.moe

## Understanding Results

### All Same IP (Green)
- No split tunneling detected
- All traffic uses single outbound path
- Example: All endpoints return `1.2.3.4`

### Different IPs (Yellow)
- Split tunneling is active
- Different paths for different endpoints
- Example: Some return `1.2.3.4`, others return `5.6.7.8`

## File Structure

```
~/addons/split_tunnel/
├── Documentation
│   ├── README.md              # Full docs (6.4KB)
│   └── QUICKSTART.md          # Quick start (4KB)
│
├── Core Files
│   ├── app.inf                # Metadata
│   ├── appctrl                # Control script
│   ├── install.sh             # Installer
│   └── uninstall.sh           # Uninstaller
│
├── bin/
│   └── quick_test.sh          # CLI tool
│
├── conf/
│   └── splitunnel.conf        # Configuration
│
├── lib/
│   └── helper.sh              # Helper functions
│
└── web/
    ├── cgi/
    │   ├── webmain            # Main page
    │   └── ajax_splitunnel    # API handler
    └── html/
        ├── css/style.css      # Styles
        └── js/splitunnel.js   # JavaScript
```

## Configuration Options

Edit `conf/splitunnel.conf`:
```bash
# Test endpoints
PRIMARY_ENDPOINTS="0.ip.skk.moe 1.ip.skk.moe ..."

# Timeouts
TEST_TIMEOUT=5
CONNECT_TIMEOUT=3

# Logging
LOG_ENABLED=1
LOG_FILE=/usr/panabit/data/split_tunnel/test.log

# Display
MAX_RESULTS_DISPLAY=20
AUTO_REFRESH_ENABLED=0
```

## Requirements

- Panabit system (any recent version)
- curl command
- Internet connectivity
- Web browser with JavaScript

## Use Cases

1. **Verify VPN Routing**: Confirm traffic flows through correct VPN tunnels
2. **Test Multi-WAN**: Check which WAN is used for different traffic
3. **Debug NAT**: Verify NAT proxy assignments
4. **Monitor Routing**: Detect routing policy changes
5. **Network Diagnostics**: Identify asymmetrical routing

## Technical Details

### Backend (CGI)
- Shell script based
- Uses curl for HTTP requests
- JSON API responses
- Integrates with floweye for routing info

### Frontend
- jQuery for AJAX
- Modern CSS with gradients
- Responsive design
- Real-time updates

### Testing Method
1. Makes HTTP request to each endpoint
2. Endpoint returns IP address of requester
3. Compares IPs across all endpoints
4. Detects if different IPs are used

## Troubleshooting

### Endpoints Timeout
- Check internet connectivity
- Verify firewall allows HTTPS outbound
- Increase timeout in configuration

### Addon Not Visible
```bash
/usr/panabit/app/split_tunnel/appctrl stop
/usr/panabit/app/split_tunnel/appctrl start
ls /usr/ramdisk/admin/cgi-bin/App/split_tunnel/
```

### Permission Errors
```bash
chmod -R 755 /usr/panabit/app/split_tunnel
chmod +x /usr/panabit/app/split_tunnel/web/cgi/*
```

## Uninstallation

```bash
sudo /usr/panabit/app/split_tunnel/uninstall.sh
```

Or manually:
```bash
sudo /usr/panabit/app/split_tunnel/appctrl stop
sudo rm -rf /usr/panabit/app/split_tunnel
sudo rm -rf /usr/ramdisk/admin/cgi-bin/App/split_tunnel
sudo rm -rf /usr/ramdisk/admin/html/App/split_tunnel
```

## Related Documentation

- `/root/ADDON.md` - Panabit addon development guide
- `/root/FLOWEYE.md` - Panabit command reference
- `/root/addons/split_tunnel/README.md` - Full documentation
- `/root/addons/split_tunnel/QUICKSTART.md` - Quick start

## Credits

- Test endpoints: [Sukka's IP Service](https://ip.skk.moe)
- Concept: Split tunnel testing tools

## License

Provided as-is for educational and diagnostic purposes.

---

**Installation Location**: `/root/addons/split_tunnel/`  
**Target Installation**: `/usr/panabit/app/split_tunnel/`  
**Web Access**: `https://<panabit-ip>/` → App → Split Tunnel

## Next Steps

1. Review the addon files
2. Run `./install.sh` to install
3. Access web interface
4. Click "Start Test"
5. Review results and detect split tunneling

---

**Created**: 2025-03-11  
**Version**: 1.0  
**Status**: Ready for deployment ✅
