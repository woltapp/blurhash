#include "decode.h" 

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_writer.h"

int main(int argc, char **argv) {
    
    if(argc < 5) {
        fprintf(stderr, "Usage: %s hash width height output_file [punch]\n", argv[0]);
        return 1;
    }

    int width, height, punch = 1;

    char * hash = argv[1];
    width = atoi(argv[2]);
    height = atoi(argv[3]);
    char * output_file = argv[4];

    if(argc == 6) 
        punch = atoi(argv[5]);
    
    unsigned char * bytes = decode(hash, width, height, punch);

    if (!bytes) {
        fprintf(stderr, "%s is not a valid blurhash, decoding failed.\n", hash);
        return 1;
    }

    if (stbi_write_png(output_file, width, height, 4, bytes, 4 * width) == 0) {
        fprintf(stderr, "Failed to write PNG file %s\n", output_file);
        return 1;
    }

    fprintf(stdout, "Decoded blurhash successfully, wrote PNG file %s\n", output_file);
    return 0;

}