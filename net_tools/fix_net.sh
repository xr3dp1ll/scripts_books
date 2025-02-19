#!/bin/bash

echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
dig google.com 

curl -s https://ipinfo.io | jq
