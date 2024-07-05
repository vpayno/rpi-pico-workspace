// This is a hello world experiment using the led on the wifi chip.
package main

import (
	"fmt"
	"time"

	cyw43439 "github.com/soypat/cyw43439"
)

func main() {
	fmt.Println("Raspberry Pi Pico W Hello World LED Blinker")

	// using https://github.com/soypat/cyw43439/blob/main/examples/blinky/blinky.go as a guide
	dev := cyw43439.NewPicoWDevice()
	cfg := cyw43439.DefaultWifiConfig()

	err := dev.Init(cfg)
	if err != nil {
		panic(err)
	}

	state := false

	// infinite loop
	for {
		if state {
			err = dev.GPIOSet(0, true)
			if err != nil {
				println("err", err.Error())
				continue
			} else {
				fmt.Println("LED: on")
			}
		} else {
			err = dev.GPIOSet(0, false)
			if err != nil {
				println("err", err.Error())
				continue
			} else {
				fmt.Println("LED: off")
			}
		}

		state = !state

		time.Sleep(time.Millisecond * 1_000)
	}
}
