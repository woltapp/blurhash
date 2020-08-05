PROGRAM=blurhash

$(PROGRAM): blurhash_stb.c encode.c encode.h stb_image.h
	$(CC) -o $@ blurhash_stb.c encode.c -lm -Ofast

.PHONY: clean
clean:
	rm -f $(PROGRAM)
