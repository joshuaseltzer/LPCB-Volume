#!/bin/bash

# Check for WiringPi installation
if ! command -v gpio &> /dev/null; then
    echo "Installing WiringPi..."
    sudo apt-get update
    sudo apt-get install -y wiringpi
fi

# Define GPIO pins for volume control
VOLUME_UP_PIN=13
VOLUME_DOWN_PIN=11

# Set GPIO pins using WiringPi
gpio export $VOLUME_UP_PIN in
gpio export $VOLUME_DOWN_PIN in

# Set pull-up resistors for the pins
gpio -g mode $VOLUME_UP_PIN up
gpio -g mode $VOLUME_DOWN_PIN up

# Python script for GPIO control of volume using WiringPi
python3 - <<EOF &
import time
import os
import wiringpi

# GPIO setup
VOLUME_UP_PIN = $VOLUME_UP_PIN
VOLUME_DOWN_PIN = $VOLUME_DOWN_PIN

# Initialize WiringPi
wiringpi.wiringPiSetupGpio()  # Initialize GPIO using BCM pin numbering

# Set GPIO pins as input with pull-up resistors enabled
wiringpi.pinMode(VOLUME_UP_PIN, wiringpi.INPUT)
wiringpi.pullUpDnControl(VOLUME_UP_PIN, wiringpi.PUD_UP)
wiringpi.pinMode(VOLUME_DOWN_PIN, wiringpi.INPUT)
wiringpi.pullUpDnControl(VOLUME_DOWN_PIN, wiringpi.PUD_UP)

def volume_up():
    os.system("batocera-audio setSystemVolume +5")
    print("Volume up")

def volume_down():
    os.system("batocera-audio setSystemVolume -5")
    print("Volume down")

try:
    print("GPIO volume control is active.")
    while True:
        if wiringpi.digitalRead(VOLUME_UP_PIN) == 0:  # Detect press
            volume_up()
            time.sleep(0.2)  # Debounce
        elif wiringpi.digitalRead(VOLUME_DOWN_PIN) == 0:  # Detect press
            volume_down()
            time.sleep(0.2)  # Debounce
        time.sleep(0.1)
except KeyboardInterrupt:
    print("Stopping GPIO volume control.")
EOF

echo "GPIO volume control running in background."
