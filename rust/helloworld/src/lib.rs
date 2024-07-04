#![no_std]
#![no_main]

pub extern crate embedded_hal;
pub extern crate panic_halt;
pub extern crate rp2040_hal;

// halt on panic
pub use panic_halt as _;

// hardware abstraction layer alias
pub use rp2040_hal as hal;

// peripheral acess crate alias
pub use hal::pac;

// traits
pub use embedded_hal::digital::v2::OutputPin;
pub use rp2040_hal::clocks::Clock;

// where the linker should place this boot block where the bootloader will find it
#[link_section = ".boot2"]
#[used]
pub static BOOT2: [u8; 256] = rp2040_boot2::BOOT_LOADER_GENERIC_03H;

// pico crystal frequency is 12 MHz
pub const XTAL_FREQ_HZ: u32 = 12_000_000u32;
