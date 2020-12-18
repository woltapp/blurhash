#ifndef __BLURHASH_DECODE_H__

#define __BLURHASH_DECODE_H

#include <math.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>

/*
	decode : Returns the pixel array of the result image given the blurhash string,
	Parameters : 
		blurhash : A string representing the blurhash to be decoded.
		width : Width of the resulting image
		height : Height of the resulting image
		punch : The factor to improve the contrast, default = 1
		nChannels : Number of channels in the resulting image array, 3 = RGB, 4 = RGBA
	Returns : A pointer to memory region where pixels are stored in (H, W, C) format
*/
uint8_t * decode(const char * blurhash, int width, int height, int punch, int nChannels);

/*
	decodeToArray : Decodes the blurhash and copies the pixels to pixelArray,
					This method is suggested if you use an external memory allocator for pixelArray.
					pixelArray should be of size : width * height * nChannels
	Parameters :
		blurhash : A string representing the blurhash to be decoded.
		width : Width of the resulting image
		height : Height of the resulting image
		punch : The factor to improve the contrast, default = 1
		nChannels : Number of channels in the resulting image array, 3 = RGB, 4 = RGBA
		pixelArray : Pointer to memory region where pixels needs to be copied.
	Returns : int, -1 if error 0 if successful
*/
int decodeToArray(const char * blurhash, int width, int height, int punch, int nChannels, uint8_t * pixelArray);

/*
	isValidBlurhash : Checks if the Blurhash is valid or not.
	Parameters :
		blurhash : A string representing the blurhash
	Returns : bool (true if it is a valid blurhash, else false)
*/
bool isValidBlurhash(const char * blurhash); 

/*
	freePixelArray : Frees the pixel array
	Parameters :
		pixelArray : Pixel array pointer which will be freed.
	Returns : void (None)
*/
void freePixelArray(uint8_t * pixelArray);

#endif
