"""Hello world that prints Hello World to the console and blinks the LED on the Pico and Pico W"""

import sys
import time

from machine import Pin, Timer


# determine if we are running on a Pico or PicoW
def is_picow_old():
    try:
        import network
    except ImportError:
        return False

    if "network" in sys.modules:
        del sys.modules["network"]
        del network

    return True


def is_picow():
    #  pico: (name='micropython', version=(1, 23, 0, ''), _machine='Raspberry Pi Pico with RP2040', _mpy=4870)
    # picow: (name='micropython', version=(1, 23, 0, ''), _machine='Raspberry Pi Pico W with RP2040', _mpy=4870)
    hw_label = sys.implementation[2]

    if hw_label == "Raspberry Pi Pico W with RP2040":
        return True

    return False


has_wifi = is_picow()

led = Pin("LED", Pin.OUT)
timer = Timer()


def hello_pico():
    print(sys.implementation)
    print()

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
