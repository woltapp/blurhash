PROGRAM=blurhash

$(PROGRAM): blurhash_stb.c encode.c encode.h stb_image.h
	$(CC) -o $@ blurhash_stb.c encode.c -lm

.PHONY: clean
clean:
	rm -f $(PROGRAM)
