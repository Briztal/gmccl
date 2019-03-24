# ZBAFF : 

As a stupidly simple generator of makefile based multi environment manager, 
ZBAFF helps managing parts of a project that depend on a specific environment.


## Problematics

Let's say that you have a project that aims to be ported on different 
environments;


### Examples

- An executable portable on different hardwares :
This kind of project requires selecting the appropriate tool-chain, 
updating the correct flags, and building the appropriate hardware-
specific code

- An application portable on different operating systems :
Same problematics as the previous example, but with different objects;
this time, the correct tool-chain must be selected, the correct OS specific 
code must be build, and the appropriate OS libraries must be included;

### Problematics

The two previous examples, and more generally any project with a part that can
be built for a set of environments, faces the following problematics :

- How to organize properly environment dependent code ?
- How to dissociate the information of environment dependencies form 
project-dependent code;
- How to select correctly, and in a minimum of pain, the code 
that should be built when the target environment has been selected ?
- How to ensure that any code related to an environment the target environment
depends on is also built ?


### Environment dependencies

The last problematic may seem a little bit obscure, but is central, 
particularly when porting a project in different architectures.

Let's say you need to port a kernel on different chips, that both are 
part of the same family, the NXP kinetis K family;
Each chip will require its specific build code, to support its own set of 
standard peripherals for example;

Both chis will share the build code related to the Kinetis K family, to 
support the set of Kinetis K system peripherals for example); This build  
code will have to be executed as soon as one of the chips is selected.

In the same way, the Kinetis K family is built arount the cortex M4, which 
is implemented from the ARMV7M architecture. Buid code for these environments 
will also have to be executed as soon as one of the chip is selected.


### One solution

A solution that solves these three problematics is the following :

- Each environment (E) the project aims to support has its own makefile;
- All environment makefiles are stored in the same directory;
- E's makefile includes the makefile of each environment E depends on;
- E's makefile includes an external makefile on the same name in another 
directory, in order to include project-dependent code;
- E's makefile does nothing else;
 
This solution has the advantage of :
- dissociating environment dependencies information from any project -
dependent code, and as a consequence, to be reusable between projects;
- supporting any kind of environment dependency model;

Nevertheless, the major disadvantage of this solution, is that environment
dependencies information, that is itself pretty simple, is contained in 
multiple decentralized makefiles, making maintaining hard to achieve;


## The ZBAFF solution

The approach of ZBAFF is to consider that environment dependencies information
is essential in itself, and must be stored as purely as possible, the set of
makefiles being only an image of this information;

ZBAFF is a simple linux (for instance) executable that, given takes a plain 
text file where a set of environments, and their dependencies are defined,
generates a set of makefile that conform to the solution described previously;


### Compiling ZBAFF

To generate the executable, enter the following command :

```bash
gcc -o zbaff zbaff.c
```


### Calling ZBAFF

The executable takes the following arguments (in order) :
- the location of the environment definition file;
- the name of the external directory variable (for makefile integration);
- the name of the directory where makefiles must be generated; this directory 
must not exist, and will be created;

To call the generator, enter the following command :

```bash
./zbaff <path_to_env_def_file> <ext_dir_variable_name> <output_dir_name>
```
 

### Environment definition file

The input file contains environment definitions, formated as the following :

```c
env_name,env_dep_0,...,env_dep_n;
```

where :
- env_name is the name of the declared environment;
- env_dep_i is the name of the i-th dependency of the declared environment,
0 <= i <= n;

## Parser

### Characters

The parser accepts the following set of characters in a name :
- letters, uppercase or lowercase;
- digits;
- underscore, '_';

The parser has a special behavior for :
- comma, ',', that separates names;
- semicolon ';', that terminates a declaration;

The parser ignores : 
- tabs, '\t';
- spaces, ' ';
- line feeds, '\n';

Any other character encountered causes the parser to fail;

### Limitations

The parser accepts all words that have a size below its size limit;
The parser allow environments to have any number of dependencies below 
its dependency number limit;

These two limits can be configures in the source file;

### Special rules

- empty names are ignored;
- comma can be omitted before a semicolon;
- semicolon can be ignored if it terminated a file;


## Generated makfiles

When invoking ZBAFF, a set of makefiles is created in the directoty you 
specified;
These makefiles are formatted as the following (variables names follow 
previous declarations) :

```makefile

#This is an automatically generated makefile, do not modify it directly;

#External makefile inclusion;

-include $(<ext_dir_var_name>)/<env_name>.mk


#Dependencies makefiles inclusion;

include <output_dir_name>/<dependency_name>.mk
... (more dependencies makefiles inclusion);


```

The file starts by one and only one facultative (-include) makefile 
inclusion; 
The directory where the makefile shall be found is not defined, and 
is contained in a makefile variable, that should have been defined by the 
caller makefile;
The name of this variable is speficied when running ZBAFF;
Then, multiple mandatory (include) makefile inclusions follow, one for 
each dependency that was declared in the environment definition file; 


