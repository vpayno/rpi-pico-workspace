"""Hello world that prints Hello World to the console and blinks the LED on the Pico and Pico W"""

import time

import board
import digitalio


def is_picow() -> bool:
    #  pico: raspberry_pi_pico
    # picow: raspberry_pi_pico_w
    hw_label = board.board_id

    if hw_label == "raspberry_pi_pico_w":
        return True

    return False


has_wifi: bool = is_picow()

led = digitalio.DigitalInOut(board.LED)
led.direction = digitalio.Direction.OUTPUT


def hello_pico() -> None:
    print(board.board_id)
    print()

    if has_wifi:
        print("Hello Pico W!\n")
    else:
        print("Hello Pico!\n")

    print()


def main_loop() -> None:
    global led

    hello_pico()

    led.value = not led.value


dir(led)

led.value = True
time.sleep(2.0)
led.value = False

while True:
    main_loop()
    time.sleep(1.0)
