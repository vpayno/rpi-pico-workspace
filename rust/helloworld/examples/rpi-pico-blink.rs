#![no_std]
#![no_main]

use core::fmt::Write;
use helloworld::*;

extern crate usb_device;

// usb device support
// use usb_device::class_prelude::UsbBus;
// use usb_device::class_prelude::*;
// use usb_device::prelude::*;

// usb serial support
// use usbd_serial::SerialPort;

// used for writing formatted strings
// use core::fmt::Write;
// use heapless::String;

// entry point
#[rp2040_hal::entry]
fn main() -> ! {
    let mut pac = rp2040_hal::pac::Peripherals::take().unwrap();
    let mut rp_pac = rp_pico::hal::pac::Peripherals::take().unwrap();

    let core = pac::CorePeripherals::take().unwrap();

    // watchdog used by clock setup code
    let mut watchdog = rp2040_hal::Watchdog::new(pac.WATCHDOG);
    let mut rp_watchdog = rp_pico::hal::Watchdog::new(rp_pac.WATCHDOG);

    // setup clocks
    let clocks = hal::clocks::init_clocks_and_plls(
        XTAL_FREQ_HZ,
        pac.XOSC,
        pac.CLOCKS,
        pac.PLL_SYS,
        pac.PLL_USB,
        &mut pac.RESETS,
        &mut watchdog,
    )
    .ok()
    .unwrap();
    let rp_clocks = rp_pico::hal::clocks::init_clocks_and_plls(
        XTAL_FREQ_HZ,
        rp_pac.XOSC,
        rp_pac.CLOCKS,
        rp_pac.PLL_SYS,
        rp_pac.PLL_USB,
        &mut rp_pac.RESETS,
        &mut rp_watchdog,
    )
    .ok()
    .unwrap();

    let timer = rp_pico::hal::Timer::new(rp_pac.TIMER, &mut rp_pac.RESETS, &rp_clocks);
    let mut delay = cortex_m::delay::Delay::new(core.SYST, clocks.system_clock.freq().to_Hz());

    // single-cycle I/O block controls GPIO pins
    let sio = hal::Sio::new(pac.SIO);

    // set pin default states
    let pins = hal::gpio::Pins::new(
        pac.IO_BANK0,
        pac.PADS_BANK0,
        sio.gpio_bank0,
        &mut pac.RESETS,
    );

    // setup usb driver
    let usb_bus = usb_device::class_prelude::UsbBusAllocator::new(rp_pico::hal::usb::UsbBus::new(
        rp_pac.USBCTRL_REGS,
        rp_pac.USBCTRL_DPRAM,
        rp_clocks.usb_clock,
        true,
        &mut rp_pac.RESETS,
    ));

    // setup usb serial comm
    let mut serial = usbd_serial::SerialPort::new(&usb_bus);

    // create usb device with fake vid and pid
    let mut usb_dev = usb_device::device::UsbDeviceBuilder::new(
        &usb_bus,
        usb_device::device::UsbVidPid(0x16c0, 0x27dd),
    )
    .strings(&[usb_device::device::StringDescriptors::default()
        .manufacturer("Raspberry Pi")
        .product("Serial port")
        .serial_number("1234")])
    .unwrap()
    .device_class(2) // https://www.usb.org/defined-class-codes
    .build();

    // set GPIO25 (LED) as an output
    let mut led_pin = pins.gpio25.into_push_pull_output();

    loop {
        led_pin.set_high().unwrap();
        delay.delay_ms(1_000);

        let _ = serial.write(b"Hello, World!\r\n");
        let time = timer.get_counter().ticks();
        let mut text: heapless::String<64> = heapless::String::new();
        writeln!(&mut text, "Current timer ticks: {}", time).unwrap();

        let _ = serial.write(text.as_bytes());

        led_pin.set_low().unwrap();
        delay.delay_ms(1_000);
    }
}
