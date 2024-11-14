#!/bin/bash

# Define the GitHub URLs
GITHUB_USER="joshuaseltzer"
GITHUB_BASE="https://raw.githubusercontent.com/$GITHUB_USER/LPCB-Volume/main"
BASH_SCRIPT="gpio_volume_control.sh"
PYTHON_SCRIPT="change_volume.py"

# Destination for the scripts
SCRIPT_DIR="/userdata/system/scripts"
BASH_SCRIPT_PATH="$SCRIPT_DIR/$BASH_SCRIPT"
PYTHON_SCRIPT_PATH="$SCRIPT_DIR/$PYTHON_SCRIPT"

# Ensure the scripts directory exists
mkdir -p "$SCRIPT_DIR"

# Download the gpio_volume_control.sh script
echo "Downloading the scripts from GitHub..."
curl -o "$BASH_SCRIPT_PATH" -L "$GITHUB_BASE/$BASH_SCRIPT"
curl -o "$PYTHON_SCRIPT_PATH" -L "$GITHUB_BASE/$PYTHON_SCRIPT"

# Make the scripts executable
chmod +x "$BASH_SCRIPT_PATH"
chmod +x "$PYTHON_SCRIPT_PATH"
echo "Downloaded and set the scripts as executable."

# Path to the custom.sh file
CUSTOM_SH="/userdata/system/custom.sh"

# Add the gpio volume control script to custom.sh if not already present
if ! grep -q "$BASH_SCRIPT_PATH" "$CUSTOM_SH" 2>/dev/null; then
    echo "Adding gpio volume control script to custom.sh for startup..."
    echo "$BASH_SCRIPT_PATH &" >> "$CUSTOM_SH"
else
    echo "gpio volume control script already present in custom.sh"
fi

echo "Setup complete. Restart Batocera to enable the GPIO volume control."
