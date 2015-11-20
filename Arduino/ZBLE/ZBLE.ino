void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  
}

void serialEvent(){
  if(Serial.available() > 0){
    String v = Serial.readString();
    Serial.println(v);
  }
}

