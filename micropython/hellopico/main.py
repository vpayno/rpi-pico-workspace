"""Hello world that prints Hello World to the console and blinks the LED on the Pico and Pico W"""

import sys
import time

from machine import Pin, Timer


# determine if we are running on a Pico or PicoW
def is_picow():
    try:
        import network
    except ImportError:
        return False

    if "network" in sys.modules:
        del sys.modules["network"]
        del network

    return True


has_wifi = is_picow()

led = Pin("LED", Pin.OUT)
timer = Timer()


def hello_pico():
    if has_wifi:
        print("Hello Pico W!\n")
    else:
        print("Hello Pico!\n")


def main_loop(timer):
    global led

    hello_pico()

    led.toggle()


led.on()
time.sleep(2)
led.off()

# hmm, instead of a while true loop
timer.init(freq=2.5, mode=Timer.PERIODIC, callback=main_loop)
