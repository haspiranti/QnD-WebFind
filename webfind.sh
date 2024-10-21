#!/bin/bash

# Define colors
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'  # No color

# Check if the file with IPs is provided
if [ -z "$1" ]; then
  echo -e "${PURPLE}Usage: $0 ip_list.txt${NC}"
  exit 1
fi

# Assign the input file to a variable
IP_FILE="$1"

# Define the list of ports to check
PORTS=(80 443 8000 8080 8443 8888)

# Iterate through each IP in the file
while IFS= read -r ip; do
  
  # Iterate through each port
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
done < "$IP_FILE"
