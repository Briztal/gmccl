/*generator.c - mftk - GPLV3, copyleft 2019 Raphael Outhier;*/

#include <string.h>

#include <stdio.h>

#include <stdlib.h>

#include "generator.h"

#define hd_error(msg) {printf(#msg);exit(1);}

/**
 * main : the entry point; 
 * Must be invoked in the command line; Parameters are :
 * - the path of the input file; 	
 * - the name of the internal dir name variable;
 * - the name of the external dir name variable;
 * - the name of the external dir check variable;
 * - the name of the external subdir check variable;
 * - the name of the output directory;
 */
int main(int argc, char *argv[])
{
	
	const char *input_file;
	const char *output_dir;
	size_t dir_len;
	char *mpath;
	char *mpath_name;
	struct gen_env env;
	FILE *f;
	char c;
	
	/*
	 * Arguments checks, vars init;
	 */
	
	/*If there are not 6 arguments :*/
	if (argc != 5) {
		
		/*Display a message;*/
		printf("Usage : %s <input_file_path> <int_dir_name_var>"
				   " <ext_dir_name_var> <output_dir_path>.\n", *argv);
		
		/*Fail;*/
		exit(1);
		
	}
	
	/*Cache the names;*/
	input_file = argv[1];
	output_dir = argv[4];
	
	f = fopen(output_dir,"r");
	
	if (!f) {
		hd_error(no dir);
	}
	
	fclose(f);
	
	/*Determine the length of the dir;*/
	dir_len = strlen(output_dir);
	
	if (!dir_len) hd_error(output
							   directory
							   name);
	
	/*Allocate an array to contain makefiles paths;*/
	mpath = malloc(dir_len + 1 + WORD_ARRAY_SIZE + 3);
	
	if (!mpath) hd_error(malloc)
	
	/*Initialise the makefie path name;*/
	mpath_name = mpath + dir_len + 1;
	
	/*Copy the directory name;*/
	memcpy(mpath, output_dir, dir_len);
	
	
	/*Write the / after the dir name;*/
	mpath[dir_len] = '/';
	
	f = fopen(input_file, "r");
	
	if (f == 0) hd_error(fopen)
	
	
	/*Initialise the environment settings;*/
	zbaff_env_init(&env, mpath, mpath_name, argv[2], argv[3]);
	
	/*Process the file;*/
	do {
		
		/*Get the current char;*/
		c = (char) fgetc(f);
		
		/*Parse the current char and stop if file ends*/
	} while (zbaff_parse(&env, c));
	
	/*Log;*/
	printf("All makefiles created;\n");
	
	/*Complete;*/
	exit(0);
	
}

