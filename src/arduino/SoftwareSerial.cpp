
// 
// Includes
// 
#include <avr/interrupt.h>
#include <avr/pgmspace.h>
#include <Arduino.h>
#include <SoftwareSerial.h>
#include <util/delay_basic.h>


#define SERIAL_PORT_TRANSMIT_PIN 8
uint8_t serialPortBitMask;
volatile uint8_t *serialPortRegister;
uint32_t serialPortDelay;

void initializeSerialPort(uint32_t speed) {
	digitalWrite(SERIAL_PORT_TRANSMIT_PIN, HIGH);
	pinMode(SERIAL_PORT_TRANSMIT_PIN, OUTPUT);
	serialPortBitMask = digitalPinToBitMask(transmitPin);
	uint8_t port = digitalPinToPort(transmitPin);
	serialPortRegister = portOutputRegister(port);
	serialPortDelay = ((F_CPU / speed) - 15) / 4;
}

void writeSerialPort(uint8_t data)
{

	// By declaring these as local variables, the compiler will put them
	// in registers _before_ disabling interrupts and entering the
	// critical timing sections below, which makes it a lot easier to
	// verify the cycle timings
	volatile uint8_t *serialPortRegisterLocal = serialPortRegister;
	uint8_t maskLocal = serialPortBitMask;
	uint8_t invertedMaskLocal = ~serialPortBitMask;
	uint32_t delay = serialPortDelay;

	uint8_t oldSREG = SREG; // save interrupt-enable state
	cli(); // disable interrupts
	*serialPortRegisterLocal &= invertedMaskLocal; // start bit
	_delay_loop_2(delay); // ...
	for (uint8_t i = 8; i > 0; i--) {
		if (data & 1) {
			*serialPortRegisterLocal |= maskLocal; // send 1
		} else {
			*serialPortRegisterLocal &= invertedMaskLocal; // send 0
		}
		_delay_loop_2(delay);
		data >>= 1;
	}
	*serialPortRegisterLocal |= maskLocal; // stop bit
	_delay_loop_2(serialPortDelay); // ...
	SREG = oldSREG; // restore interrupts

}
