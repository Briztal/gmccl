#include <stdbool.h>

#include <stdint.h>

#include <stddef.h>

#define MAX_NB_WORDS 10

#define MAX_WORD_SIZE 100
#define WORD_ARRAY_SIZE (MAX_WORD_SIZE + 1)


/**
 * zbaff_mf_dsc : contains all data required to properly generate
 *  makefiles;
 */

struct zbaff_mf {
	
	/*Makefile path container; Large enough to contain any makefile path;*/
	char *m_mpath;
	
	/*Location in path container where makefile names can be copied;*/
	char *m_mpath_name;
	
	/*Nt name of the external dir variable;*/
	char *m_edir_vname;
	
	/*Nt name of the internal dir variable;*/
	char *m_idir_vname;
	
};


/** 
 * zbaff_parsing : contains the parsing context; it stores words and status
 *  variables;
 */

struct zbaff_parsing {
	
	
	/*Lines from the beginning of the file;*/
	size_t p_line_counter;
	
	/*Chars from the beginning of the line;*/
	size_t p_char_counter;
	
	/*A names array, to contain environment and dependencies names;*/
	char p_words[MAX_NB_WORDS][WORD_ARRAY_SIZE];
	
	/*A size array to contain words sizes;*/
	size_t p_sizes[MAX_NB_WORDS];
	
	/*The size of the current word;*/
	size_t p_csize;
	
	/*The number of words saved;*/
	size_t p_nb;
	
	/*The place the next char must be saved;*/
	char *p_cchar;
	
};


/**
 * zbaff_env : contains a parsing environment, and data required to properly 
 *  generate the related makefile;
 */

struct zbaff_env {
	
	/*The makefile generation environment;*/
	struct zbaff_mf e_mf;
	
	/*The parsing context;*/
	struct zbaff_parsing e_parsing;
	
};


/*Initialise an environment;*/
void zbaff_env_init(
	struct zbaff_env *env,
	char *mpath,
	char *mpath_name,
	char *idir_vname,
	char *edir_vname
);


/*Parse a character;*/
bool zbaff_parse(struct zbaff_env *env, char c);



