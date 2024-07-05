// This is a hello world experiment using the neopixel.
package main

import (
	"fmt"
	"machine"
	"time"
)

func main() {
	fmt.Println("Raspberry Pi Pico/Pico W Hello World LED Blinker")

	// https://learn.adafruit.com/adafruit-kb2040/pinouts
	var led machine.Pin = machine.LED
	led.Configure(machine.PinConfig{Mode: machine.PinOutput})

	state := false

	// infinite loop
	for {
		if state {
			fmt.Println("LED: on")
			led.High()
		} else {
			fmt.Println("LED: off")
			led.Low()
		}

		state = !state

		time.Sleep(time.Millisecond * 1_000)
	}
}
