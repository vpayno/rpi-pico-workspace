#include "pico/stdlib.h"
#include <stdio.h>

#ifndef PICO_DEFAULT_LED_PIN
// Pico W LED blinking using the WiFi chip.
void pico_blink() {}
#else
// Legacy LED blinking.
void pico_blink() {
  const uint LED_PIN = PICO_DEFAULT_LED_PIN;
  gpio_init(LED_PIN);
  gpio_set_dir(LED_PIN, GPIO_OUT);

  int led_state = 1;

  while (true) {
    gpio_put(LED_PIN, (led_state++ % 2));
    sleep_ms(500);
  }
}
#endif

int main() {
  pico_blink();
  return 0;
}
