ZBAFF_PATH := ../zbaff/zbaff

.PHONY:regenerate_arch

regenerate_arch:

#Remove the arch directory if it is present;
	-rm -rf arch

#Generate the arch makefile system in arch/ from arch.txt;
	$(ZBAFF_PATH) arch.txt __IDIR__ __EDIR__ __CED__ __CESD__ arch


