

CFLAGS := -Wall -O3 -std=c89 -pedantic

CC := gcc $(CFLAGS) -Isrc/

.PHONY:env_gen clean


clean:
	rm -rf environments


clean_all: clean
	rm -rf generator/build



generator:
	mkdir -p build
	$(CC) -o build/main.o -c src/main.c
	$(CC) -o build/env_gen.o -c src/env_gen.c
	$(CC) -o build/env_gen build/main.o build/env_gen.o


MYDIR := environments
envs : $(MYDIR)/*
	@echo $^


all: clean generator envs
