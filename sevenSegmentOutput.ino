// ---------- FPGA → Arduino UART Inputs ----------
#define Y1_SERIAL Serial1   // RX1 pin 19  → ja[0]
#define Y2_SERIAL Serial2   // RX2 pin 17  → ja[1]
#define Y3_SERIAL Serial3   // RX3 pin 15  → ja[2]

const int resetPin = 6;     // FPGA reset signal (from ja[4])

// ---------- Shift-register control pins ----------
const int DS_pin   = 8;     // SER / DS
const int STCP_pin = 9;     // RCLK / LATCH / LOAD
const int SHCP_pin = 10;    // SRCLK / CLOCK

// ---------- Digit-enable pins ----------
const int d1_pin = 7;
const int d2_pin = 11;
const int d3_pin = 12;
const int d4_pin = 13;

// ---------- Data storage ----------
int number[3] = {0, 0, 0};      // display values
int lastNumber[3] = {-1, -1, -1}; // debounce

byte segMap[11] = {
  B11111100, // 0
  B00001100, // 1
  B11011010, // 2
  B11110010, // 3
  B01100110, // 4
  B10110110, // 5
  B10111110, // 6
  B11100000, // 7
  B11111110, // 8
  B11100110, // 9
  B00000000  // blank
};


// ---------------- Setup ----------------
void setup() {
  Serial.begin(9600);        // USB serial monitor
  Y1_SERIAL.begin(9600);     // must match FPGA transmitter baud
  Y2_SERIAL.begin(9600);
  Y3_SERIAL.begin(9600);

  pinMode(resetPin, INPUT);
  pinMode(DS_pin,   OUTPUT);
  pinMode(STCP_pin, OUTPUT);
  pinMode(SHCP_pin, OUTPUT);

  pinMode(d1_pin, OUTPUT);
  pinMode(d2_pin, OUTPUT);
  pinMode(d3_pin, OUTPUT);
  pinMode(d4_pin, OUTPUT);

  digitalWrite(d1_pin, HIGH);
  digitalWrite(d2_pin, HIGH);
  digitalWrite(d3_pin, HIGH);
  digitalWrite(d4_pin, HIGH);

  Serial.println("Listening for FPGA UART data...");
}


// ---------------- Loop ----------------
void loop() {
  bool resetActive = digitalRead(resetPin) == HIGH;

  // --- If FPGA reset is pressed, show 000 visually ---
  if (resetActive) {
    number[0] = 0;
    number[1] = 0;
    number[2] = 0;
    lastNumber[0] = 0;
    lastNumber[1] = 0;
    lastNumber[2] = 0;
    displayNumber(number[0], number[1], number[2]);
  }
  else {
    // --- UART read logic (always active) ---
    if (Y1_SERIAL.available()) {
      int val = Y1_SERIAL.read();
      if (val != lastNumber[0]) {
        number[0] = val;
        lastNumber[0] = val;
        Serial.print("Y1 = "); Serial.println(val);
      }
    }

    if (Y2_SERIAL.available()) {
      int val = Y2_SERIAL.read();
      if (val != lastNumber[1]) {
        number[1] = val;
        lastNumber[1] = val;
        Serial.print("Y2 = "); Serial.println(val);
      }
    }

    if (Y3_SERIAL.available()) {
      int val = Y3_SERIAL.read();
      if (val != lastNumber[2]) {
        number[2] = val;
        lastNumber[2] = val;
        Serial.print("Y3 = "); Serial.println(val);
      }
    }

    // --- Display current numbers ---
    displayNumber(number[0], number[1], number[2]);
  }
}


// ---------- Display function ----------
void displayNumber(int n1, int n2, int n3) {
  showDigit(n1 % 10, d1_pin);
  showDigit(n2 % 10, d2_pin);
  showDigit(n3 % 10, d3_pin);
  showDigit(10, d4_pin); // blank
}

void showDigit(int n, int digitPin) {
  // turn all digits off
  digitalWrite(d1_pin, HIGH);
  digitalWrite(d2_pin, HIGH);
  digitalWrite(d3_pin, HIGH);
  digitalWrite(d4_pin, HIGH);

  shiftOut(DS_pin, SHCP_pin, MSBFIRST, segMap[n]);
  digitalWrite(STCP_pin, HIGH);
  digitalWrite(STCP_pin, LOW);

  // enable this digit
  digitalWrite(digitPin, LOW);
  delay(2);
  digitalWrite(digitPin, HIGH);
}
