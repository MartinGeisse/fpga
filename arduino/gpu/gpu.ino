
#include <avr/interrupt.h>
#include <avr/pgmspace.h>
#include <Arduino.h>
#include <util/delay_basic.h>

#define SWAP_INTEGERS(a,b)   a ^= b; b ^= a; a ^= b;
#define SORT_INTEGERS(a,b)   if (a > b) {SWAP_INTEGERS(a, b);}
#define SORT_INTEGERS_WITH_ATTACHMENTS(a,a2,b,b2)   if (a > b) {SWAP_INTEGERS(a, b);SWAP_INTEGERS(a2, b2);}

uint8_t sineTable[] = {
  30,
  30,
  31,
  32,
  33,
  34,
  35,
  36,
  37,
  38,
  39,
  40,
  41,
  41,
  42,
  43,
  44,
  44,
  45,
  46,
  46,
  47,
  47,
  48,
  48,
  48,
  49,
  49,
  49,
  49,
  49,
  49,
  50,
  49,
  49,
  49,
  49,
  49,
  49,
  48,
  48,
  48,
  47,
  47,
  46,
  46,
  45,
  44,
  44,
  43,
  42,
  41,
  41,
  40,
  39,
  38,
  37,
  36,
  35,
  34,
  33,
  32,
  31,
  30,
  30,
  29,
  28,
  27,
  26,
  25,
  24,
  23,
  22,
  21,
  20,
  19,
  18,
  18,
  17,
  16,
  15,
  15,
  14,
  13,
  13,
  12,
  12,
  11,
  11,
  11,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  10,
  11,
  11,
  11,
  12,
  12,
  13,
  13,
  14,
  15,
  15,
  16,
  17,
  18,
  18,
  19,
  20,
  21,
  22,
  23,
  24,
  25,
  26,
  27,
  28,
  29,
};

uint8_t sin(int index) {
  return sineTable[index];
}

uint8_t cos(int index) {
  index += 32;
  if (index >= 128) {
    index -= 128;
  }
  return sineTable[index];
}

void drawRotating(int index, uint8_t color) {
  uint8_t x = cos(index);
  uint8_t y = sin(index);
  Serial.write(0);
  Serial.write(color);
  /*
  Serial.write(2);
  Serial.write(x);
  Serial.write(y);
  */
  Serial.write(5);
  Serial.write(30);
  Serial.write(30);
  Serial.write(x);
  Serial.write(y);
  
}

uint8_t keyboardOutputY = 0;

void showKeyboardOutput(char c) {
  uint8_t i;
  for (i=0; i<8; i++) {
    Serial.write(0);
    Serial.write(((c >> i) & 1) ? 2 : 4);
    Serial.write(2);
    Serial.write(100 - i - (i >> 2));
    Serial.write(keyboardOutputY);
  }
  keyboardOutputY++;
}

void drawHorizontallyCutTriangle(uint8_t x1, uint8_t y1, uint8_t x2, uint8_t x3, uint8_t y23, uint8_t deltaY, uint8_t denominator, bool drawHorizontalEdge) {
  SORT_INTEGERS(x2,x3);
  int8_t leftXFraction = 0, rightXFraction = 0;
  uint8_t leftX = x1, rightX = x1, y = y1;
  while (true) {
    
    leftXFraction += x2 - x1;
    while (leftXFraction >= denominator) {
      leftXFraction -= denominator;
      leftX++;
    }
    while (leftXFraction <= -denominator) {
      leftXFraction += denominator;
      leftX--;
    }
    
    rightXFraction += x3 - x1;
    while (rightXFraction >= denominator) {
      rightXFraction -= denominator;
      rightX++;
    }
    while (rightXFraction <= -denominator) {
      rightXFraction += denominator;
      rightX--;
    }

    Serial.write(3);
    Serial.write(leftX);
    Serial.write(y);
    Serial.write(rightX);

    if (drawHorizontalEdge) {
      y += deltaY;
      if (y == y23) {
        break;
      }
    } else {
      if (y == y23) {
        break;
      }
      y += deltaY;
    }
    
  };
}

void drawTriangle(uint8_t x1, uint8_t y1, uint8_t x2, uint8_t y2, uint8_t x3, uint8_t y3) {
  SORT_INTEGERS_WITH_ATTACHMENTS(y1,x1,y2,x2);
  SORT_INTEGERS_WITH_ATTACHMENTS(y2,x2,y3,x3);
  SORT_INTEGERS_WITH_ATTACHMENTS(y1,x1,y2,x2);
  if (y1 == y2) {
    drawHorizontallyCutTriangle(x3, y3, x1, x2, y1, -1, y3 - y1, true);
  } else if (y2 == y3) {
    drawHorizontallyCutTriangle(x1, y1, x2, x3, y2, 1, y2 - y1, true);
  } else {
    int16_t x4 = y2 - y1;
    x4 *= x3 - x1;
    x4 /= y3 - y1;
    x4 += x1;
    drawHorizontallyCutTriangle(x1, y1, x2, x4, y2, 1, y2 - y1, true);
    drawHorizontallyCutTriangle(x3, y3, x2, x4, y2, -1, y3 - y2, false);
  }
}

void drawQuad(uint8_t x1, uint8_t y1, uint8_t x2, uint8_t y2, uint8_t x3, uint8_t y3, uint8_t x4, uint8_t y4) {
  drawTriangle(x1, y1, x2, y2, x3, y3);
  drawTriangle(x1, y1, x3, y3, x4, y4);
}

void setup() {

  Serial.begin(10000);

  // reset the GPU
  digitalWrite(7, HIGH);
  pinMode(7, OUTPUT);
  _delay_loop_2(0);
  digitalWrite(7, LOW);

  // clear screen to blue
  Serial.write(0);
  Serial.write(1);
  Serial.write(1);

  // draw rotating point / line
  /*
  int index=0;
  while (true) {
    drawRotating(index, 1);
    index++;
    if (index == 128) {
      index = 0;
    }
    drawRotating(index, 4);
    for (int i=0; i<2; i++) {
      _delay_loop_2(0);
    }
  }
  */

/*
  // draw horizontal red line
  Serial.write(0);
  Serial.write(4);
  Serial.write(3);
  Serial.write(2);
  Serial.write(1);
  Serial.write(10);

  // draw vertical purple line
  Serial.write(0);
  Serial.write(5);
  Serial.write(4);
  Serial.write(1);
  Serial.write(2);
  Serial.write(10);
*/

  Serial.write(0);
  Serial.write(1);
  Serial.write(1);
  
  // Serial.write(0);
  // Serial.write(6);
  // void drawHorizontallyCutTriangle(uint8_t x1, uint8_t y1, uint8_t x2, uint8_t x3, uint8_t y23, uint8_t deltaY, uint8_t denominator)
  // drawHorizontallyCutTriangle(5, 2, 3, 10, 20, 1, 18);
  // drawHorizontallyCutTriangle(20 + 5, 20, 20 + 3, 20 + 10, 2, -1, 18);

  Serial.write(0);
  Serial.write(6);
  // drawTriangle(20 + random(10), random(10), 20 + random(10), random(10), 20 + random(10), random(10));
  // drawTriangle(60, 5, 20, 100, 100, 50);

  drawQuad(20, 20, 100, 30, 80, 100, 10, 80);

}

void loop() {
  uint8_t c;
  if (Serial.available() > 0) {
    c = Serial.read();
    showKeyboardOutput(c);
  }
}

