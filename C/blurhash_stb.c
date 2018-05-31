#include "encode.h"

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#include <stdio.h>

const char *blurHashForFile(int xComponents, int yComponents,const char *filename);

int main(int argc, const char **argv) {
	if(argc != 4) {
		fprintf(stderr, "Usage: %s x_components y_components imagefile\n", argv[0]);
		return 1;
	}

	int xComponents = atoi(argv[1]);
	int yComponents = atoi(argv[2]);
	if(xComponents < 1 || xComponents > 8 || yComponents < 1 || yComponents > 8) {
		fprintf(stderr, "Component counts must be between 1 and 8.\n");
		return 1;
	}

	const char *hash = blurHashForFile(xComponents, yComponents, argv[3]);
	if(!hash) {
		fprintf(stderr, "Failed to load image file \"%s\".\n", argv[3]);
		return 1;
	}

	printf("%s\n", hash);

	return 0;
}

const char *blurHashForFile(int xComponents, int yComponents,const char *filename) {
	int width, height, channels;
	unsigned char *data = stbi_load(filename, &width, &height, &channels, 3);
	if(!data) return NULL;

	const char *hash = blurHashForPixels(xComponents, yComponents, width, height, data, width * 3);

	stbi_image_free(data);

	return hash;
}
