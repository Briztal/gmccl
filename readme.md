# MFTK

MFTK is a set of makefile functions, defined in mftk.mk, that aim to provide 
a makefile interface to enhance projects interoperability;

It does it by defining two high level concepts :
- makefile utility : an utility only concerns the first execution phase of make, 
when the makefile tree is parsed. 
Based on makefile inclusion, it aims to provide build information to the 
makefile that executes it;
- makefile node: a node concerns the second execution phase of make, when 
rules are called; 
Based on makefile sub-call, it aims to execute a complete step of build;

MFTK provides built-in utilities, namely :
- cross-make : an architecture dependent makefile inclusion utility; 
- toolchain : a toolchain selection utility for cross compilation;
- arch-info : an architecture information provider;

Both toolchain and arch_info are using cross-make;

## In brief

### Downloading MFTK

To use mftk, download the source code, and update the environment with :

```bash
git pull https://github.com/Briztal/mftk mftk
```

This will clone the project in your file system;

### Configuring MFTK

The following steps can be re-done any time you need with no restriction;

#### Search directories

You need to tell mftk where it should search for your makefile utilities and 
nodes;
To do this, add paths you want it to search in in the `search_dirs` file;
The search is of depth 1, meaning that mftk will not search recursively in the 
provided directories;

#### Environments setup

When using the cross_make utility, you must specify which environment you 
want to use; 
Environments are makefile dependency trees, generated from environment 
description text files;
Environment description files are located in `internal/utils/cross_make/desc`
You are free to add and modify any environment description file; By default, 
only the arch environment is provided.

#### Update

When you have configured mftk, you must update it so your modifications are 
applied;

To do this, type (copy) the following commands:

```bash
cd mftk/internal
make update
cd ../..
```

Calling make update will :
- re-compile the environment generator located in 
`internal/utils/cross_make/gen`;
this step could be avoided but it takes less than one second;
- regenerate all environments you provided in `internal/utils/cross_make/desc`;
- search for new utilities and nodes to register and generate related 
registrations in `internal/auto_utils.mk` and `internal/auto_nodes.mk`;

When mftk has been updated, you can use it freely

### Including MFTK

To use mftk in one of your makefiles, include the file `mftk.mk` present in 
the project's main directory; 
Your makefile will then have access to all MFTK's features, and will be able 
to execute utilities and nodes;

## A brief reminder about makefiles;

variables : a variable is a makefile string containing any character except 
```=``` ```=``` or ```=```, that refers to another string; 
It can be defined directly using a =-like (= ?= += ...) operator, or indirectly
using keywords define ... endef;
Later, it can be referred to using $([variable_name])

functions : a function is a variable that incorporates references to arguments 
(temporary variables) $(1), $(2), etc..., that are replaced during the expansion
of the function;
It can be called using $(call $(func_name),arg1,arg2,...)

eval : eval must be used when the result of the expansion of a variable / 
function must be interpreted by gnu-make as makefile syntax and not just 
as variable name or content; 
Any variable / function provided to eval is expanded twice : one time as text, 
and another time as makefile syntax;
Its syntax is $(eval $(variable_name)), with a special reference to the 
god-blessed $(eval $(call func_name,arg1,arg2,...)) that expands the provided 
function and interprets the result as makefile syntax;

## Naming policy

When dealing with sub-makes, by make sub-call or inclusion, using variables 
can get messy, as variables with temporary use may have simple name (clearly, 
try avoiding foo = 1), and make doesn't recognise the notion of context : any 
definition will override definitions with the same name;

### Namespaces

As stated earlier, makefiles variables or functions names can contain any 
character except ```=``` ```#``` or ```:```, and in particular, they can 
contain```.```

To tackle the previous issue, as it defines multiple functions and internal 
variables, mftk uses namespaces, taking advantage of the possibility to include 
```.``` in names;

A variable will be said to be in the namespace of ```B``` (with ```B```
containing eventually one or several ```.```) if the variable has the prefix
```B.``` in its name; 

The following rules are applied :
- any function / internal variable related to mftk will be in the namespace of
```mftk```
- any variable provided to or used by a node or an utility named ```A``` will 
be in the namespace of ```A```;

### Naming constraints

As a consequence to the namespace policy no utility, node or related variable 
name should :
- contain the character ```.```;
- contain spaces;
- (consequence) present leading or trailing whitespaces;

All functions provided by MFTK regarding on utilities and modules, in addition 
to their respective functions, ensure that the naming policy is respected for 
all relevant arguments;

## Makefile Utility

A makefile utility is a standalone makefile, that requires arguments, and aims 
to provide any information that has a meaning in the first execution phase of 
make;
Its usage is limited to make's first phase of execution, meaning that 
using any mftk's utilities function is forbidden in a rule (first because it
makes no sense, and then because the execution would fail);

### Registration

A makefile utility is registered automatically at the initialization of mftk. 
A registered utility can't be unregistered;
At its registration, a makefile utility provides its name that must be unique, 
and the path for its entry makefile;
No utility function can be called on an unregistered utility.

### Arguments

A makefile utility receives arguments, in the form of variables with names 
that follow mftk's naming policy, that are used to control its behaviour;
For example, the toolchain utility requires the variable toolchain.target, 
providing the architecture for which the toolchain should be selected;

### Behavior

When called, a makefile utility may define variables, update variables, 
define rules, print data, include other makefiles, or do any other action 
related to make's first execution phase;
After the makefile is called, any variable in his namespace is automatically 
undefined;

### Tools

MFTK provides the following functions to deal with utilities :

Function | Description
---- | -------------
mftk.utility.register(util_name) | registers an utility to mftk;
mftk.utility.require(util_name) | fails if an utility is not registered to mftk;
mftk.utility.define(util_name,var_name,var_value) | defines the argument variable util_name.var_name and sets it to var_value
mftk.utility.execute(util_name) | includes the utility's makefile, and undefines any argument variable defined with mftk.utility.define;
