
CFLAGS := -Wall -O3 -std=c89 -pedantic 

CC := gcc $(CFLAGS) -Isrc/

.PHONY:env_gen clean

env_gen: 
	mkdir -p build
	$(CC) -o build/main.o -c src/main.c
	$(CC) -o build/env_gen.o -c src/env_gen.c
	$(CC) -o build/env_gen build/main.o build/env_gen.o

clean : 
	rm -rf build
