ZBAFF_PATH := ../zbaff/zbaff

.PHONY:clean generate all

clean :
	rm -rf arch

generate:
	$(ZBAFF_PATH) arch.txt __IDIR__ __EDIR__ __CED__ __CESD__ arch


all: clean generate

