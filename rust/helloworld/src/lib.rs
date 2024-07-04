#![no_std]
#![no_main]

pub extern crate embedded_hal;
pub extern crate panic_halt;
pub extern crate rp2040_hal;

#[cfg(feature = "rt")]
extern crate cortex_m_rt;

// halt on panic
pub use panic_halt as _;

// hardware abstraction layer alias
pub use rp2040_hal as hal;

// peripheral acess crate alias
pub use hal::pac;

// traits
pub use embedded_hal::digital::OutputPin;
pub use rp2040_hal::clocks::Clock;
// pub use usb_device::class_prelude::UsbBus;
// pub use rp2040_hal::usb::UsbBus;
// pub use usb_device::class_prelude::UsbBusAllocator;

// where the linker should place this boot block where the bootloader will find it
#[cfg(feature = "boot2")]
#[link_section = ".boot2"]
#[no_mangle]
#[used]
pub static BOOT2_FIRMWARE: [u8; 256] = rp2040_boot2::BOOT_LOADER_W25Q080;

// pico crystal frequency is 12 MHz
pub const XTAL_FREQ_HZ: u32 = 12_000_000u32;
