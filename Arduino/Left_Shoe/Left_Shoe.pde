String foot = "L";
String data;

void setup()
{
  Serial.begin(57600);
  pinMode(A0,INPUT);
  pinMode(A1,INPUT);
  pinMode(A2,INPUT);
  pinMode(A3,INPUT);
  pinMode(A4,INPUT);
  pinMode(A5,INPUT);
}

void loop()
{
  data = foot
       + ","  
       + String(analogRead(A0))
       + ","
       + String(analogRead(A1))
       + ","
       + String(analogRead(A2))
       + ","
       + String(analogRead(A3))
       + ","
       + String(analogRead(A4))
       + ","
       + String(analogRead(A5));
  Serial.println(data);
  delay(20);
}
