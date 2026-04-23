#!/bin/bash

# Define variables
SERVICE_URL="https://raw.githubusercontent.com/thegremlinlives/disable-cpu-boost.service"
SERVICE_DEST="/etc/systemd/system/disable-cpu-boost.service"

# Download the service file directly to the destination
sudo curl -sSL "$SERVICE_URL" -o "$SERVICE_DEST"

# Set standard permissions (root-owned, 644)
sudo chown root:root "$SERVICE_DEST"
sudo chmod 644 "$SERVICE_DEST"

# Reload and activate
sudo systemctl daemon-reload
sudo systemctl enable --now disable-cpu-boost.service

# Final Check
STATUS=$(cat /sys/devices/system/cpu/cpufreq/boost)
if [ "$STATUS" = "0" ]; then
    echo "Done: CPU Boost is disabled."
else
    echo "Error: CPU Boost is still active."
fi

