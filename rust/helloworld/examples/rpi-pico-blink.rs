#![no_std]
#![no_main]

use helloworld::*;

// entry point
#[rp2040_hal::entry]
fn main() -> ! {
    let mut pac = pac::Peripherals::take().unwrap();
    let core = pac::CorePeripherals::take().unwrap();

    // watchdog used by clock setup code
    let mut watchdog = hal::Watchdog::new(pac.WATCHDOG);

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

    let mut timer = cortex_m::delay::Delay::new(core.SYST, clocks.system_clock.freq().to_Hz());

    // single-cycle I/O block controls GPIO pins
    let sio = hal::Sio::new(pac.SIO);

    // set pin default states
    let pins = hal::gpio::Pins::new(
        pac.IO_BANK0,
        pac.PADS_BANK0,
        sio.gpio_bank0,
        &mut pac.RESETS,
    );

    // set GPIO25 (LED) as an output
    let mut led_pin = pins.gpio25.into_push_pull_output();

    loop {
        led_pin.set_high().unwrap();
        timer.delay_ms(1_000);
        led_pin.set_low().unwrap();
        timer.delay_ms(1_000);
    }
}
