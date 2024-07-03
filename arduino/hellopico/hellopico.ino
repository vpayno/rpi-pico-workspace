// the setup routine runs once when you press reset:
void setup() {
  Serial.begin(115200);

  pinMode(LED_BUILTIN, OUTPUT);
}

// the loop routine runs over and over again forever:
void loop() {
  delay(500);

  if (rp2040.isPicoW()) {
    Serial.println("Hello Pico W!");
  } else {
    Serial.println("Hello Pico!");
  }

  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
}
