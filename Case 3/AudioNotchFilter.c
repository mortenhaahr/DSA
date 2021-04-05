
/*********************************************************************************

Copyright(c) 2015 Analog Devices, Inc. All Rights Reserved.

This software is proprietary and confidential.  By using this software you agree
to the terms of the associated Analog Devices License Agreement.

Modified by Kim Bjerge, Aarhus University, 27-06-2017

*********************************************************************************/

#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "AudioCallback.h"

#define SAMPLES_PER_CHAN   (NUM_AUDIO_SAMPLES/2)

// Input samples, 24 LSBs
int32_t inLeft[SAMPLES_PER_CHAN];
int32_t inRight[SAMPLES_PER_CHAN];

// Output samples, 24 LSBs
int32_t outLeft[SAMPLES_PER_CHAN];
int32_t outRight[SAMPLES_PER_CHAN];

#define QUANT_SHIFT 14

int xBuffer[2] = {0};
int yBuffer[2] = {0};
short b0 = 1.000 * (1 << QUANT_SHIFT);
short b1 = -1.9894 * (1 << QUANT_SHIFT);
short b2 = 1.000 * (1 << QUANT_SHIFT);
short a1 = 1.9695 * (1 << QUANT_SHIFT); // Note flipped sign
short a2 = -0.9801 * (1 << QUANT_SHIFT); // Note flipped sign

// Processing mode BYPASS or FILTER active
FILTER_MODE currentMode = PASS_THROUGH;

/* initialize the IIR filter, called once when button PB1 pressed */
void FilterInit(FILTER_MODE mode)
{
	switch (mode)
	{
		case PASS_THROUGH:
			currentMode = PASS_THROUGH;
			printf("Pass through\n");
			break;
		case IIR_FILTER_ACTIVE:
			currentMode = IIR_FILTER_ACTIVE;
			printf("Filter on\n");
			break;
	}
}

// Modify and insert your notch filter here!!!!
short myNotchFilter(short x)
{

	int y = b0*x + b1*xBuffer[0] + b2*xBuffer[1] + a1*yBuffer[0] + a2*yBuffer[1];
	xBuffer[1] = xBuffer[0];
	xBuffer[0] = x;
	yBuffer[1] = yBuffer[0];
	yBuffer[0] = y >> QUANT_SHIFT;

	// Attenuation
	return yBuffer[0];
}

/* Compute filter response or bypass  */
void AudioNotchFilter(const int32_t dataIn[], int32_t dataOut[])
{
	int n, i;
	short xn, yn;

	// Copy dataIn to left/right input buffers
	i = 0;
	for (n=0; n<SAMPLES_PER_CHAN; n++){
		inLeft[n] = dataIn[i++];
		inRight[n] = dataIn[i++];
	}

	// Perform pass through or filtering
	switch (currentMode)
	{
		case PASS_THROUGH:
			// Copy input to output
			for (n=0; n<SAMPLES_PER_CHAN; n++)
			{
				outLeft[n] = inLeft[n];
				outRight[n] = inRight[n];
			}
			break;

		case IIR_FILTER_ACTIVE:
			// IIR filter active
			for (n=0; n<SAMPLES_PER_CHAN; n++)
			{
				// Filter in left channel only
				xn = inLeft[n]>>8; // 24 bits samples right aligned, remove 8 LSBs
				yn = myNotchFilter(xn);
				outLeft[n] = yn << 8;

				// Mute right channel
				xn = 0; //inRight[n]>>8; // 24 bits samples right aligned, remove 8 LSBs
				outRight[n] = xn << 8;
			}
			break;

	}

	i = 0;
	// Copy left/right output buffers to dataOut
	for (n=0; n<SAMPLES_PER_CHAN; n++){
		dataOut[i++] = outLeft[n];
		dataOut[i++] = outRight[n];
	}

}
