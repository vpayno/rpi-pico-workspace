#include "pico/stdlib.h"
#include <stdio.h>

void pico_blink() {
  const uint LED_PIN = PICO_DEFAULT_LED_PIN;
  gpio_init(LED_PIN);
  gpio_set_dir(LED_PIN, GPIO_OUT);

  int led_state = 1;

  while (true) {
    gpio_put(LED_PIN, (led_state++ % 2));

    printf("Hello Pico!\n");

    sleep_ms(500);
  }
}

int main() {
  setup_default_uart();

  pico_blink();

  return 0;
}
