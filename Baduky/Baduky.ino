#include <Keyboard.h>
void setup() {
  Keyboard.begin();
  delay(1000);
  Keyboard.press(KEY_LEFT_GUI);
  delay(10);
  Keyboard.releaseAll();
  delay(200);
  Keyboard.print("cmd");
  Keyboard.press(KEY_RETURN);
  delay(10);
  Keyboard.releaseAll();
  delay(1000);
  Keyboard.print("echo 'Weeeilaaa'");
  delay(200);
  Keyboard.press(KEY_RETURN);
  Keyboard.releaseAll();
  delay(200);
  Keyboard.end();
}
void loop() {}
