#!/bin/bash

SERVICE_DEST="/etc/systemd/system/disable-cpu-boost.service"

# 1. Unlock SteamOS
sudo steamos-readonly disable

# 2. Complete Cleanup
sudo systemctl disable disable-cpu-boost.service --now >/dev/null 2>&1
sudo rm -f "$SERVICE_DEST"

# 3. Create the file using a clean heredoc
# We use /bin/sh -c to ensure the redirect happens inside a shell context
sudo tee "$SERVICE_DEST" > /dev/null <<'EOF'
[Unit]
Description=Disable CPU Boost
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/bin/bash -c "echo 0 > /sys/devices/system/cpu/cpufreq/boost"
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# 4. Standardize File Permissions
sudo chmod 644 "$SERVICE_DEST"
sudo chown root:root "$SERVICE_DEST"

# 5. Reload and Start
sudo systemctl daemon-reload
if sudo systemctl enable --now disable-cpu-boost.service; then
    echo "SUCCESS: Service installed and boost disabled."
    # Verify the actual hardware state
    echo "Current Boost State: $(cat /sys/devices/system/cpu/cpufreq/boost)"
else
    echo "FAIL: Check 'systemctl status disable-cpu-boost.service' for the specific line error."
fi

# 6. Re-lock SteamOS
sudo steamos-readonly enable

