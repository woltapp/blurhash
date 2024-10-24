PROGRAM=blurhash_encoder
DECODER=blurhash_decoder

encod%.o: encod%.c encode.h stb_image.h common.h
	$(CC) -c $< -o $@ -Ofast -Wall
$(PROGRAM): encode_stb.o encode.o
	$(CC) -o $@ encode_stb.o encode.o -lm

decod%.o: decod%.c decode.h stb_writer.h common.h
	$(CC) -c $< -o $@ -Ofast -Wall
$(DECODER): decode_stb.o decode.o
	$(CC) -o $@ decode_stb.o decode.o -lm

.PHONY: clean
clean:
	rm -f $(PROGRAM)
	rm -f $(DECODER)
	rm -f *.o
