blurhash: blurhash.c encode.c encode.h stb_image.h
	$(CC) -o $@ blurhash.c encode.c

.PHONY: extensions
extensions: python ruby

.PHONY: python
python: BlurHash.i encode.h
	swig -outdir ../Python/ -o ../Python/BlurHash.c -python BlurHash.i

.PHONY: ruby
ruby: BlurHash.i encode.h
	swig -outdir ../Ruby/ -o ../Ruby/BlurHash.c -ruby BlurHash.i
