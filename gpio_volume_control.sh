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

# Define GPIO pins for volume control
VOLUME_UP_PIN=13
VOLUME_DOWN_PIN=11

# Python script for GPIO control of volume
python3 - <<EOF &
import pigpio
import time
import os

# GPIO setup
VOLUME_UP_PIN = $VOLUME_UP_PIN
VOLUME_DOWN_PIN = $VOLUME_DOWN_PIN
pi = pigpio.pi()
if not pi.connected:
    print("Could not connect to pigpiod.")
    exit(1)

# Configure GPIO pins with pull-up resistors
pi.set_mode(VOLUME_UP_PIN, pigpio.INPUT)
pi.set_pull_up_down(VOLUME_UP_PIN, pigpio.PUD_UP)
pi.set_mode(VOLUME_DOWN_PIN, pigpio.INPUT)
pi.set_pull_up_down(VOLUME_DOWN_PIN, pigpio.PUD_UP)

def volume_up():
    os.system("amixer sset 'Master' 5%+")
    print("Volume up")

def volume_down():
    os.system("amixer sset 'Master' 5%-")
    print("Volume down")

try:
    print("GPIO volume control is active.")
    while True:
        if pi.read(VOLUME_UP_PIN) == 0:  # Detect press
            volume_up()
            time.sleep(0.2)  # Debounce
        elif pi.read(VOLUME_DOWN_PIN) == 0:  # Detect press
            volume_down()
            time.sleep(0.2)  # Debounce
        time.sleep(0.1)
except KeyboardInterrupt:
    print("Stopping GPIO volume control.")
finally:
    pi.stop()
EOF

echo "GPIO volume control running in background."