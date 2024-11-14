#!/bin/bash

# Check for pigpio installation
if ! command -v pigpiod &> /dev/null; then
    echo "Installing pigpio..."
    sudo apt-get update
    sudo apt-get install -y pigpio python3-pigpio
fi

# Start pigpiod if not already running
if ! pgrep pigpiod > /dev/null; then
    echo "Starting pigpiod..."
    sudo pigpiod
fi

# Python script for GPIO control of volume
nohup python3 change_volume.py --continuous & > ~/gpio_volume_control.log

echo "GPIO volume control running in background."
