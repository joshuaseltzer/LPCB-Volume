#!/usr/bin/python3

import argparse
import os
import pigpio
import time


VOLUME_UP_PIN = 13
VOLUME_DOWN_PIN = 11


def gpio_setup():
    # GPIO setup
    gpio = pigpio.pi()
    if not gpio.connected:
        print("Could not connect to pigpiod.")
        exit(1)

    # Configure GPIO pins with pull-up resistors
    gpio.set_mode(VOLUME_UP_PIN, pigpio.INPUT)
    gpio.set_pull_up_down(VOLUME_UP_PIN, pigpio.PUD_UP)
    gpio.set_mode(VOLUME_DOWN_PIN, pigpio.INPUT)
    gpio.set_pull_up_down(VOLUME_DOWN_PIN, pigpio.PUD_UP)

    return gpio


def volume_up():
    os.system("batocera-audio setSystemVolume +5")
    print("Volume up")


def volume_down():
    os.system("batocera-audio setSystemVolume -5")
    print("Volume down")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    arg_group = parser.add_mutually_exclusive_group(required=True)
    arg_group.add_argument(
        "-u",
        "--test_volume_up",
        help="Tests the volume up functionality and then exits.",
        action="store_true"
    )
    arg_group.add_argument(
        "-d",
        "--test_volume_down",
        help="Tests the volume down functionality and then exits.",
        action="store_true"
    )
    arg_group.add_argument(
        "-c",
        "--continuous",
        help="Runs the program indefinitely monitoring the GPIO pins to change the volume.",
        action="store_true"
    )
    args = parser.parse_args()

    if args.test_volume_up:
        volume_up()
        exit(0)
    elif args.test_volume_down:
        volume_down()
        exit(0)
    elif args.continuous:
        gpio = setup()
        try:
            print("GPIO volume control is active.")
            while True:
                if gpio.read(VOLUME_UP_PIN) == 0:  # Detect press
                    volume_up()
                    time.sleep(0.2)  # Debounce
                elif gpio.read(VOLUME_DOWN_PIN) == 0:  # Detect press
                    volume_down()
                    time.sleep(0.2)  # Debounce
                time.sleep(0.1)
        except KeyboardInterrupt:
            print("Stopping GPIO volume control.")
        finally:
            gpio.stop()
            exit(0)