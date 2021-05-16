BIN_DIR=../bin

CC=gcc
CFLAGS=-lm

all: doc2term

output:
	mkdir -p ../bin
doc2term : doc2term.c
	$(CC) doc2term.c -o ${BIN_DIR}/doc2term $(CFLAGS)

clean:
	pushd ${BIN_DIR} && rm -rf doc2term; popd
