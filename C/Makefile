PROGRAM=blurhash
DECODER=blurhash_decoder
$(PROGRAM): blurhash_stb.c encode.c encode.h stb_image.h
	$(CC) -o $@ blurhash_stb.c encode.c -lm

$(DECODER): decoder/decode_main.c decoder/decode.c decoder/decode.h decoder/stb_writer.h
	$(CC) -o $(DECODER) decoder/decode_main.c decoder/decode.c  -Idecoder/ -lm

.PHONY: clean
clean:
	rm -f $(PROGRAM)
	rm -f $(DECODER)