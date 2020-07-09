#include "encode.h"

#include <string.h>
#include <math.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

static void multiplyBasisFunction(float *result, int xComponent, int yComponent, int width, int height, uint8_t *rgb, size_t bytesPerRow);
static char *encode_int(int value, int length, char *destination);

static int linearTosRGB(float value);
static float sRGBToLinear(int value);
static int encodeDC(float r, float g, float b);
static int encodeAC(float r, float g, float b, float maximumValue);
static float signPow(float value, float exp);

const char *blurHashForPixels(int xComponents, int yComponents, int width, int height, uint8_t *rgb, size_t bytesPerRow) {
	static char buffer[2 + 4 + (9 * 9 - 1) * 2 + 1];

	if(xComponents < 1 || xComponents > 9) return NULL;
	if(yComponents < 1 || yComponents > 9) return NULL;

	float factors[yComponents][xComponents][3];
	memset(factors, 0, sizeof(factors));

	for(int y = 0; y < yComponents; y++) {
		for(int x = 0; x < xComponents; x++) {
			multiplyBasisFunction(factors[y][x], x, y, width, height, rgb, bytesPerRow);
		}
	}

	float *dc = factors[0][0];
	float *ac = dc + 3;
	int acCount = xComponents * yComponents - 1;
	char *ptr = buffer;

	int sizeFlag = (xComponents - 1) + (yComponents - 1) * 9;
	ptr = encode_int(sizeFlag, 1, ptr);

	float maximumValue;
	if(acCount > 0) {
		float actualMaximumValue = 0;
		for(int i = 0; i < acCount * 3; i++) {
			actualMaximumValue = fmaxf(fabsf(ac[i]), actualMaximumValue);
		}

		int quantisedMaximumValue = (int)fmax(0, fmin(82, floor(actualMaximumValue * 166 - 0.5)));
		maximumValue = ((float)quantisedMaximumValue + 1) / 166;
		ptr = encode_int(quantisedMaximumValue, 1, ptr);
	} else {
		maximumValue = 1;
		ptr = encode_int(0, 1, ptr);
	}

	ptr = encode_int(encodeDC(dc[0], dc[1], dc[2]), 4, ptr);

	for(int i = 0; i < acCount; i++) {
		ptr = encode_int(encodeAC(ac[i * 3 + 0], ac[i * 3 + 1], ac[i * 3 + 2], maximumValue), 2, ptr);
	}

	*ptr = 0;

	return buffer;
}

static void multiplyBasisFunction(float *result, int xComponent, int yComponent, int width, int height, uint8_t *rgb, size_t bytesPerRow) {
	float r = 0, g = 0, b = 0;
	float normalisation = (xComponent == 0 && yComponent == 0) ? 1.f : 2.f;

	for(int y = 0; y < height; y++) {
		for(int x = 0; x < width; x++) {
			float basis = cosf((float)M_PI * xComponent * x / width) * cosf((float)M_PI * yComponent * y / height);
			r += basis * sRGBToLinear(rgb[3 * x + 0 + y * bytesPerRow]);
			g += basis * sRGBToLinear(rgb[3 * x + 1 + y * bytesPerRow]);
			b += basis * sRGBToLinear(rgb[3 * x + 2 + y * bytesPerRow]);
		}
	}

	float scale = normalisation / (width * height);

	result[0] = r * scale;
	result[1] = g * scale;
	result[2] = b * scale;
}

static int linearTosRGB(float value) {
	float v = fmaxf(0, fminf(1, value));
	if(v <= 0.0031308) return (int)(v * 12.92 * 255 + 0.5);
	else return (int)((1.055 * powf(v, 1.f / 2.4f) - 0.055) * 255 + 0.5);
}

static float sRGBToLinear(int value) {
	float v = (float)value / 255;
	if(v <= 0.04045) return v / 12.92f;
	else return powf((v + 0.055f) / 1.055f, 2.4f);
}

static int encodeDC(float r, float g, float b) {
	int roundedR = linearTosRGB(r);
	int roundedG = linearTosRGB(g);
	int roundedB = linearTosRGB(b);
	return (roundedR << 16) + (roundedG << 8) + roundedB;
}

static int encodeAC(float r, float g, float b, float maximumValue) {
	int quantR = (int)fmaxf(0.f, fminf(18.f, floorf(signPow(r / maximumValue, 0.5f) * 9 + 9.5f)));
	int quantG = (int)fmaxf(0.f, fminf(18.f, floorf(signPow(g / maximumValue, 0.5f) * 9 + 9.5f)));
	int quantB = (int)fmaxf(0.f, fminf(18.f, floorf(signPow(b / maximumValue, 0.5f) * 9 + 9.5f)));

	return quantR * 19 * 19 + quantG * 19 + quantB;
}

static float signPow(float value, float exp) {
	return copysignf(powf(fabsf(value), exp), value);
}

static const char characters[]="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#$%*+,-.:;=?@[]^_{|}~";

static char *encode_int(int value, int length, char *destination) {
	int divisor = 1;
	for(int i = 0; i < length - 1; i++) divisor *= 83;

	for(int i = 0; i < length; i++) {
		int digit = (value / divisor) % 83;
		divisor /= 83;
		*destination++ = characters[digit];
	}
	return destination;
}
