

CFLAGS := -Wall -O3 -std=c89 -pedantic

CC := gcc $(CFLAGS) -Isrc/


.PHONY: clean
clean:
	rm -rf env
	rm -rf gen/build


.PHONY: generator
generator:
	mkdir -p gen/build
	$(CC) -o gen/build/main.o -c gen/src/main.c
	$(CC) -o gen/build/generator.o -c gen/src/generator.c
	$(CC) -o gen/build/generator gen/build/main.o gen/build/generator.o



DESCRIPTORS := $(wildcard desc/*)

ENVS := $(DESCRIPTORS:desc/%=env/%)

.PHONY: env/%
env/% : desc/%
	mkdir -p $@
	gen/build/generator $^ cross_make.int_dir cross_make.directory $@


.PHONY: envs
envs : $(ENVS)


.PHONY: setup
setup: clean generator envs

