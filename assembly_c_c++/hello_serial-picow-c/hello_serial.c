#include "pico/cyw43_arch.h"
#include "pico/stdlib.h"
#include <stdio.h>

void picow_blink() {
  stdio_init_all();

  if (cyw43_arch_init()) {
    printf("Wi-Fi init failed");
    return;
  }

  int led_state = 1;

  while (true) {
    cyw43_arch_gpio_put(CYW43_WL_GPIO_LED_PIN, (led_state++ % 2));

    printf("Hello Pico!\n");

    sleep_ms(500);
  }
}

int main() {
  setup_default_uart();

  picow_blink();

  return 0;
}
