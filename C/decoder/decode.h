#ifndef __DECODER_H

#define __DECODER_H

#include <math.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>


unsigned char * decode(const char * blurhash, int width, int height, int punch);

#endif