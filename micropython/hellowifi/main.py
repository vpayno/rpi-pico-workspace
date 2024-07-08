"""Bare minimum program for connecting to WiFi."""

import sys
import time

import appsecrets
import network
import ubinascii
from machine import Pin, Timer

wlan = network.WLAN(network.STA_IF)
wlan.active(True)
wlan.connect(appsecrets.ssid, appsecrets.password)
mac = ubinascii.hexlify(network.WLAN().config("mac"), ":").decode()

led = Pin("LED", Pin.OUT)
timer = Timer()


def main_loop(timer: Timer) -> None:
    print(sys.implementation)
    print()

    led.on()
    time.sleep(1)

    print("Connected to WIFI: ", appsecrets.ssid)
    print()
    print("       MAC: ", mac)
    print("IP Address: ", wlan.ifconfig()[0])
    print("   Netmask: ", wlan.ifconfig()[1])
    print("   Gateway: ", wlan.ifconfig()[2])
    print("       DNS: ", wlan.ifconfig()[3])
    print()

    led.off()
    time.sleep(1)
    print()


timer.init(freq=2.5, mode=Timer.PERIODIC, callback=main_loop)
