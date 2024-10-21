#!/bin/bash

# Define colors
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'  # No color

# Check if an argument is provided
if [ -z "$1" ]; then
  echo -e "${PURPLE}Usage: $0 <ip_address|ip_list.txt>${NC}"
  exit 1
fi

# Define the list of ports to check
PORTS=(80 443 8000 8080 8443 8888)

# Function to check IP and ports
check_ip() {
  local ip=$1
  for port in "${PORTS[@]}"; do
    # Curl the IP and port without SSL, display HTTP response code only
    response=$(curl -s -o /dev/null -w "%{http_code}" http://$ip:$port)

    # If the response code is 301 or 302, check for HTTPS
    if [[ "$response" == "301" || "$response" == "302" ]]; then
      response=$(curl -s -o /dev/null -w "%{http_code}" --head https://$ip:$port)
      protocol="https"
    else
      protocol="http"
    fi

    # Only print the output if the response code is not '000'
    if [ "$response" != "000" ]; then
      # Format and display the output
      echo -e "${PURPLE}[*]${NC} ${GREEN}$response${NC} : ${YELLOW}${protocol}://$ip:$port/${NC}"
    fi
  done
}

# Check if the argument is a file or a single IP
if [ -f "$1" ]; then
  IP_FILE="$1"
  # Iterate through each IP in the file
  while IFS= read -r ip; do
    check_ip "$ip"
  done < "$IP_FILE"
else
  # Assume the argument is a single IP address
  check_ip "$1"
fi
