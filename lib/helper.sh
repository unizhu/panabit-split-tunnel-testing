#!/bin/sh

# Split Tunnel Helper Library
# Common functions for split tunnel testing

# Get current timestamp
get_timestamp()
{
    date '+%Y-%m-%d %H:%M:%S'
}

# Log message
log_message()
{
    local level="$1"
    local message="$2"
    local logfile="${LOG_FILE:-/usr/panabit/data/split_tunnel/test.log}"
    
    if [ "${LOG_ENABLED:-1}" = "1" ]; then
        # Create log directory if needed
        mkdir -p $(dirname "$logfile") 2>/dev/null
        
        # Append log entry
        echo "[$(get_timestamp)] [$level] $message" >> "$logfile"
        
        # Rotate log if too large
        if [ -f "$logfile" ]; then
            size=$(stat -f%z "$logfile" 2>/dev/null || stat -c%s "$logfile" 2>/dev/null)
            if [ "$size" -gt "${LOG_MAX_SIZE:-1048576}" ]; then
                mv "$logfile" "${logfile}.old"
            fi
        fi
    fi
}

# Validate IP address format
validate_ip()
{
    local ip="$1"
    
    if echo "$ip" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'; then
        return 0
    else
        return 1
    fi
}

# Get IP information from endpoint
fetch_ip()
{
    local endpoint="$1"
    local timeout="${2:-5}"
    
    result=$(curl -s -m ${timeout} "https://${endpoint}/json" 2>/dev/null)
    
    if [ $? -eq 0 ] && [ -n "$result" ]; then
        echo "$result"
        return 0
    else
        # Fallback to simple IP
        ip=$(curl -s -m ${timeout} "https://${endpoint}" 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$ip" ]; then
            echo "{\"ip\":\"$ip\"}"
            return 0
        fi
    fi
    
    echo "{\"error\":\"timeout\"}"
    return 1
}

# Compare IP addresses
compare_ips()
{
    local ip1="$1"
    local ip2="$2"
    
    if [ "$ip1" = "$ip2" ]; then
        echo "same"
        return 0
    else
        echo "different"
        return 1
    fi
}

# Get routing information
get_routing_info()
{
    # Get default route
    local gateway=$(route -n get default 2>/dev/null | grep "gateway" | awk '{print $2}')
    local interface=$(route -n get default 2>/dev/null | grep "interface" | awk '{print $2}')
    
    echo "gateway=${gateway:-unknown}"
    echo "interface=${interface:-unknown}"
}

# Get interface IPs
get_interface_ips()
{
    ifconfig -a 2>/dev/null | awk '
        /^[a-z]/ {
            iface=$1
            gsub(/:/, "", iface)
        }
        /inet / && !/127\.0\.0\.1/ {
            split($2, ip, " ")
            print iface "=" ip[1]
        }
    '
}

# Check if running in Panabit environment
is_panabit()
{
    if [ -f /etc/PG.conf ] && [ -x /usr/ramdisk/bin/floweye ]; then
        return 0
    else
        return 1
    fi
}

# JSON escape function
json_escape()
{
    local str="$1"
    str=$(echo "$str" | sed 's/\\/\\\\/g')
    str=$(echo "$str" | sed 's/"/\\"/g')
    str=$(echo "$str" | sed 's/\t/\\t/g')
    str=$(echo "$str" | sed 's/\r/\\r/g')
    str=$(echo "$str" | sed 's/\n/\\n/g')
    echo "$str"
}

# URL encode function
url_encode()
{
    local str="$1"
    local encoded=""
    local i=0
    local len=${#str}
    
    while [ $i -lt $len ]; do
        c=${str:$i:1}
        case "$c" in
            [a-zA-Z0-9.~_-]) encoded="${encoded}${c}" ;;
            *) encoded="${encoded}$(printf '%%%02X' "'$c")" ;;
        esac
        i=$((i + 1))
    done
    
    echo "$encoded"
}
