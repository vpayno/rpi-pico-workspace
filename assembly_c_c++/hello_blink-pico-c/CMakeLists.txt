# https://www.raspberrypi.com/documentation/microcontrollers/c_sdk.html#sdk-setup

cmake_minimum_required(VERSION 3.13)

# set the environment variable
set(ENV{PICO_SDK_PATH} "../pico-sdk")
set(ENV{PICO_BOARD} "pico")

# initialize the SDK based on PICO_SDK_PATH note: this must happen before
# project()
include(../pico-sdk/external/pico_sdk_import.cmake)

project(my_project)

# initialize the Raspberry Pi Pico SDK
pico_sdk_init()

# rest of your project

add_executable(hello_blink hello_blink.c)

# Add pico_stdlib library which aggregates commonly used features
target_link_libraries(hello_blink pico_stdlib)

# create map/bin/hex/uf2 file in addition to ELF.
pico_add_extra_outputs(hello_blink)
