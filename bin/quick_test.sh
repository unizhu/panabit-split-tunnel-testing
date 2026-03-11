#!/bin/sh

# Split Tunnel Test - Quick Test Script
# Can be run from command line for quick testing

RAMDISK=/usr/ramdisk
FLOWEYE=/usr/ramdisk/bin/floweye

# Test endpoints
ENDPOINTS="0.ip.skk.moe 1.ip.skk.moe 2.ip.skk.moe 3.ip.skk.moe 4.ip.skk.moe"

echo "========================================="
echo "Split Tunnel Routing Test"
echo "========================================="
echo ""

# Test each endpoint
for endpoint in ${ENDPOINTS}; do
    printf "Testing %-20s ... " "${endpoint}"
    
    # Get IP address
    ip=$(curl -s -m 5 "https://${endpoint}" 2>/dev/null)
    
    if [ $? -eq 0 ] && [ -n "$ip" ]; then
        # Validate IP format
        if echo "$ip" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'; then
            echo "✓ IP: $ip"
        else
            echo "✗ Invalid response: $ip"
        fi
    else
        echo "✗ Timeout/Error"
    fi
done

echo ""
echo "========================================="
echo "System Routing Information"
echo "========================================="

# Show default gateway
default_gw=$(route -n get default 2>/dev/null | grep "gateway" | awk '{print $2}')
default_if=$(route -n get default 2>/dev/null | grep "interface" | awk '{print $2}')

echo "Default Gateway: ${default_gw:-unknown}"
echo "Default Interface: ${default_if:-unknown}"
echo ""

# Show NAT proxies if available
if [ -x ${FLOWEYE} ]; then
    echo "NAT Proxies:"
    ${FLOWEYE} nat listproxy type=all 2>/dev/null | head -5
    echo ""
fi

# Show local IPs
echo "Local Interface IPs:"
ifconfig | grep "inet " | awk '{print "  " $2}' | grep -v 127.0.0.1

echo ""
echo "========================================="
echo "Test Complete"
echo "========================================="
