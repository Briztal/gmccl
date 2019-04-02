#include "generator.h"

#include <string.h>

#include <stdlib.h>

#include <stdio.h>


static void parsing_error(struct zbaff_parsing *p, const char *msg)
{
	
	printf("error at position %d - %d : ",
		   (int) p->p_line_counter, (int) p->p_char_counter);
	printf(msg);
	printf("\n");
	exit(1);
	
}

static void reset_words(struct zbaff_parsing *p)
{
	
	/*Reset the number of words;*/
	p->p_nb = 0;
	
	/*Reset the current char;*/
	p->p_cchar = &(p->p_words[0][0]);
	
	/*Reset the current word size;*/
	p->p_csize = 0;
	
}


static void save_word(struct zbaff_parsing *p)
{
	
	size_t word_id;
	size_t p_csize;
	
	word_id = p->p_nb;
	p_csize = p->p_csize;
	
	/*If the current word is empty :*/
	if (p_csize == 0) {
		
		/*Fail, no word to save;*/
		return;
		
	}
	
	/*Null terminate the word;*/
	*(p->p_cchar) = 0;
	
	/*Print the word;*/
	printf("word saved : %s\n", &(p->p_words[word_id][0]));
	
	/*Save the size and increment the index;*/
	p->p_sizes[word_id++] = p_csize;
	
	/*Update the index;*/
	p->p_nb = word_id;
	
	/*Reset the current word size;*/
	p->p_csize = 0;
	
	/*Update the current char ref; gets zeroed if no more space;*/
	p->p_cchar = (word_id == MAX_NB_WORDS) ? 0 : &p->p_words[word_id][0];
	
}


static void save_char(struct zbaff_parsing *p, const char c)
{
	char *ref;
	size_t csize;
	
	/*Cache the location of the current char;*/
	ref = p->p_cchar;
	csize = p->p_csize;
	
	/*If the ref is null :*/
	if (!ref) {
		
		parsing_error(p, "too much dependencies.");
		
	}
	
	/*If there is no space in the current word array :*/
	if (csize == MAX_WORD_SIZE) {
		
		parsing_error(p, "word too long.");
		
	}
	
	/*Increment the word size;*/
	p->p_csize = csize + 1;
	
	/*Save the char;*/
	*ref = c;
	
	/*Update the current character;*/
	p->p_cchar++;
	
}


static void create_makefile(struct zbaff_env *ev)
{
	
	size_t nb_words;
	const char *words;
	const size_t *sizes;
	size_t dep_id;
	struct zbaff_mf *mf;
	struct zbaff_parsing *p;
	FILE *f;
	
	mf = &(ev->e_mf);
	p = &(ev->e_parsing);
	
	words = &(p->p_words[0][0]);
	sizes = p->p_sizes;
	
	/*Cache the number of words in the environment;*/
	nb_words = p->p_nb;
	
	/*If there are no words, do nothing;*/
	if (!nb_words)
		return;
	
	/*Log;*/
	printf("Creating makefile for %s\n", words);
	
	/*Initialise the f name;*/
	memcpy(mf->m_mpath_name, words, *sizes);
	
	/*Add the extension and null terminate;*/
	memcpy(mf->m_mpath_name + *sizes, ".mk", 4);
	
	
	
	/*Create and open the target makefile;*/
	f = fopen(mf->m_mpath, "w");
	
	fprintf(f,
			"#This is an automatically generated makefile,"
				" please do not modify it;\n\n"
				"#External makefile inclusion;\n");
	
	
	/*Write the external inclusion section;*/
	fprintf(
		f,
		"-include $(%s)/%s.mk\n\n",
		mf->m_edir_vname, words
	);
	
	
	fprintf(f, "#Dependencies makefiles inclusion;\n");
	
	for (dep_id = 1; dep_id < nb_words; dep_id++) {
		
		fprintf(f, "include $(%s)/%s.mk\n",
				mf->m_idir_vname, &(p->p_words[dep_id][0]));
		
	}
	
	fprintf(f, "\n");
	
	fclose(f);
	
}


/*Initialise an environment;*/
void zbaff_env_init(
	struct zbaff_env *env,
	char *mpath,
	char *mpath_name,
	char *idir_vname,
	char *edir_vname
)
{
	
	/*Initialise makefile settings;*/
	env->e_mf.m_mpath = mpath;
	env->e_mf.m_mpath_name = mpath_name;
	env->e_mf.m_idir_vname = idir_vname;
	env->e_mf.m_edir_vname = edir_vname;

	/*Initialise paser environment;*/
	env->e_parsing.p_line_counter = 0;
	env->e_parsing.p_char_counter = 0;
	
	/*Reset word storage;*/
	reset_words(&env->e_parsing);
	
}

bool zbaff_parse(struct zbaff_env *ev, char c)
{
	
	struct zbaff_parsing *p = &ev->e_parsing;
	
	/*If the end of the file is reached :*/
	if (c == EOF) {
		
		/*Save the current word in the desc;*/
		save_word(p);
		
		/*Generate the parsed environment if required;*/
		create_makefile(ev);
		
		/*Complete;*/
		return false;
	}
	
	
	/*If line break :*/
	if (c == '\n') {
		
		p->p_line_counter++;
		p->p_char_counter = 0;
		return true;
	}
	
	/*If no line break, increment the char counter;*/
	p->p_char_counter++;
	
	
	/*If the character must be skipped, complete;*/
	if ((c == ' ') || (c == '\t')) {
		
		/*If the character is a number, a letter or an underscore :*/
	} else if (((c >= '0') && (c <= '9')) ||
			   ((c >= 'A') && (c <= 'Z')) ||
			   ((c >= 'a') && (c <= 'z')) || (c == '_')) {
		
		/*Append the char to the current word;*/
		save_char(p, c);
		
		/*If the current char is a comma :*/
	} else if (c == ',') {
		
		/*Save the current word;*/
		save_word(p);
		
		/*If it is semicolon :*/
	} else if (c == ';') {
		
		/*Save the current word;*/
		save_word(p);
		
		/*Generate the parsed environment if required;*/
		create_makefile(ev);
		
		/*Reset the parsing environment;*/
		reset_words(p);
	}
	
	return true;
	
}



