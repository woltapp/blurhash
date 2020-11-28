PROGRAM=blurhash_encoder
DECODER=blurhash_decoder
$(PROGRAM): encode_stb.c encode.c encode.h stb_image.h common.h
	$(CC) -o $@ encode_stb.c encode.c -lm

$(DECODER): decode_stb.c decode.c decode.h stb_writer.h common.h
	$(CC) -o $(DECODER) decode_stb.c decode.c -lm

.PHONY: clean
clean:
	rm -f $(PROGRAM)
	rm -f $(DECODER)