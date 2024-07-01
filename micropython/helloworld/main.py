"""MicroPython Hello World that prints Hello World to the console and blinks the LED on the Pico."""

import time

from machine import Pin

led = Pin("LED", Pin.OUT)

while True:
    led.toggle()
    print("Hello World!\n")
    time.sleep(1.0)
