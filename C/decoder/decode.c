#include "decode.h"

#define NUMERIC_ASCII_START 48
#define UPPER_ALPHA_ASCII_START 65
#define LOWER_ALPHA_ASCII_START 97

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

static char chars[83] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#$%*+,-.:;=?@[]^_{|}~";

/*
	Image processing functions start
*/

static float sRGBToLinear(int value) {
	float v = (float)value / 255;
	if(v <= 0.04045) return v / 12.92;
	else return powf((v + 0.055) / 1.055, 2.4);
}

static float signPow(float value, float exp) {
	return copysignf(powf(fabsf(value), exp), value);
}

static int linearTosRGB(float value) {
	float v = fmaxf(0, fminf(1, value));
	if(v <= 0.0031308) return v * 12.92 * 255 + 0.5;
	else return (1.055 * powf(v, 1 / 2.4) - 0.055) * 255 + 0.5;
}

/*
	Image processing functions end
*/

/*
	decoder helper functions start
*/

static inline unsigned char clamp_to_ubyte(int * src) {
	return (unsigned char)((*src >= 0 && *src <= 255) ? *src : 0);
}


static inline unsigned char *  create_byte_array(int size) {
	return (unsigned char *)malloc(size * sizeof(unsigned char));
}

/*
	decoder helper functions end
*/


/*
	Base-83 decoder start
*/

float decode_to_int(const char * string, int start, int end) {
	int value = 0, itr_1 = 0, itr_2 = 0;
	for( itr_1 = start; itr_1 < end; itr_1 ++) {

		int index = -1;
		for(itr_2 = 0; itr_2 < 83; itr_2 ++) {
			if (chars[itr_2] == string[itr_1]) {
				index = itr_2;
				break;
			}
		}

		if (index == -1) return -1;
		value = value * 83 + index;
	}

	return value;
}

/*
	Base-83 decoder end
*/

/*
	Blurhash functions start
*/

bool is_valid_blurhash(const char * string) {

	const int hash_length = strlen(string);

	if ( !string || strlen(string) < 6) return false;

	int sizeFlag = decode_to_int(string, 0, 1);	//Get size from first character
	int num_y = (int)floorf(sizeFlag / 9) + 1;
	int num_x = (sizeFlag % 9) + 1;

	if (hash_length != 4 + 2 * num_x * num_y) return false;

	return true;
}

void decodeDc(int value, float * r, float * g, float * b) {
	*r = sRGBToLinear(value >> 16); 	// R-component

	*g = sRGBToLinear((value >> 8) & 255); // G-Component

	*b = sRGBToLinear(value & 255);	// B-Component

}


void decodeAc(int value, float maximumValue, float * r, float * g, float * b) {

    int quantR = (int)floorf(value / (19 * 19));
	int quantG = (int)floorf(value / 19) % 19;
	int quantB = (int)value % 19;


	*r = signPow(((float)quantR - 9) / 9, 2.0) * maximumValue;

	*g = signPow(((float)quantG - 9) / 9, 2.0) * maximumValue;

	*b = signPow(((float)quantB - 9) / 9, 2.0) * maximumValue;
}


unsigned char * decode(const char * blurhash, int width, int height, int punch) {

	if (! is_valid_blurhash(blurhash)) return NULL;

	int size_flag = decode_to_int(blurhash, 0, 1);
	int num_y = (int)floorf(size_flag / 9) + 1;
	int num_x = (size_flag % 9) + 1;
	int iter = 0;

	float r = 0, g = 0, b = 0;

	int quantizedMaxValue = decode_to_int(blurhash, 1, 2);
	if (quantizedMaxValue == -1) return NULL;

	float maxValue = ((float)(quantizedMaxValue + 1)) / 166;


	int colors_size = num_x * num_y;
	float colors[colors_size][3];

	for(iter = 0; iter < colors_size; iter ++) {
		if (iter == 0) {
			int value = decode_to_int(blurhash, 2, 6);
			if (value == -1) return NULL;
			decodeDc(value, &r, &g, &b);
			colors[iter][0] = r;
			colors[iter][1] = g;
			colors[iter][2] = b;

		} else {
			int value = decode_to_int(blurhash, 4 + iter * 2, 6 + iter * 2);
			if (value == -1) return NULL;
			decodeAc(value, maxValue * punch, &r, &g, &b);
			colors[iter][0] = r;
			colors[iter][1] = g;
			colors[iter][2] = b;
		}
	}

	int bytesPerRow = width * 4;
	int x = 0, y = 0, i = 0, j = 0;
	int intR = 0, intG = 0, intB = 0;

	unsigned char * pixel_array = create_byte_array(bytesPerRow * height);

	for(y = 0; y < height; y ++) {
		for(x = 0; x < width; x ++) {

			float r = 0, g = 0, b = 0;

			for(j = 0; j < num_y; j ++) {
				for(i = 0; i < num_x; i ++) {
					float basics = cos((M_PI * x * i) / width) * cos((M_PI * y * j) / height);
					int idx = i + j * num_x;
					r += colors[idx][0] * basics;
					g += colors[idx][1] * basics;
					b += colors[idx][2] * basics;
				}
			}

			intR = linearTosRGB(r);
			intG = linearTosRGB(g);
			intB = linearTosRGB(b);

			pixel_array[4 * x + 0 + y * bytesPerRow] = clamp_to_ubyte(&intR);
			pixel_array[4 * x + 1 + y * bytesPerRow] = clamp_to_ubyte(&intG);
			pixel_array[4 * x + 2 + y * bytesPerRow] = clamp_to_ubyte(&intB);

			pixel_array[4 * x + 3 + y * bytesPerRow] = 255;
		}
	}

	return pixel_array;

}
