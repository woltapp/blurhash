# BlurHash encoder in portable C

This code implements an encoder for the BlurHash algorithm in C. It can be used to integrate into other language
using an FFI interface. Currently the Python integration uses this code.

## Usage as a library

Include the `encode.c` and `encode.h` files in your project. They have no external dependencies.

A single file function is defined:

    const char *blurHashForPixels(int xComponents, int yComponents, int width, int height, uint8_t *rgb, size_t bytesPerRow) {

This function returns a string containing the BlurHash. This memory is managed by the function, and you should not free it.
It will be overwritten on the next call into the function, so be careful!

* `xComponents` - The number of components in the X direction. Must be between 1 and 9. 3 to 5 is usually a good range for this.
* `yComponents` - The number of components in the Y direction. Must be between 1 and 9. 3 to 5 is usually a good range for this.
* `width` - The width in pixels of the supplied image.
* `height` - The height in pixels of the supplied image.
* `rgb` - A pointer to the pixel data. This is supplied in RGB order, with 3 bytes per pixels.
* `bytesPerRow` - The number of bytes per row of the RGB pixel data.

## Usage as a command-line tool

You can also build a command-line version to test the encoder and decoder. However, note that it uses `stb_image` to load images,
which is not really security-hardened, so it is **not** recommended to use this version in production on untrusted data!
Use one of the integrations instead, which use more robust image loading libraries.

Nevertheless, if you want to try it out quickly, simply run:

	$ make blurhash_encoder
	$ ./blurhash_encoder 4 3 ../Swift/BlurHashTest/pic1.png
	LaJHjmVu8_~po#smR+a~xaoLWCRj

If you want to try out the decoder, simply run:
	$ make blurhash_decoder
	$ ./blurhash_decoder "LaJHjmVu8_~po#smR+a~xaoLWCRj" 32 32 decoded_output.png