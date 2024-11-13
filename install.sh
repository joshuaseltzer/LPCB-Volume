#!/bin/bash

# Define the GitHub URL for gpio_volume_control.sh
GITHUB_URL="https://raw.githubusercontent.com/RySe96/LPCB-Volume/main/gpio_volume_control.sh"

# Destination for the gpio control script
SCRIPT_DIR="/userdata/system/scripts"
SCRIPT_PATH="$SCRIPT_DIR/gpio_volume_control.sh"

# Ensure the scripts directory exists
mkdir -p "$SCRIPT_DIR"

# Download the gpio_volume_control.sh script
echo "Downloading gpio_volume_control.sh from GitHub..."
curl -o "$SCRIPT_PATH" -L "$GITHUB_URL"

# Make the gpio control script executable
chmod +x "$SCRIPT_PATH"
echo "Downloaded and set gpio_volume_control.sh as executable."

# Path to the custom.sh file
CUSTOM_SH="/userdata/system/custom.sh"

# Add the gpio volume control script to custom.sh if not already present
if ! grep -q "$SCRIPT_PATH" "$CUSTOM_SH" 2>/dev/null; then
    echo "Adding gpio volume control script to custom.sh for startup..."
    echo "$SCRIPT_PATH &" >> "$CUSTOM_SH"
else
    echo "gpio volume control script already present in custom.sh"
fi

echo "Setup complete. Restart Batocera to enable the GPIO volume control."
