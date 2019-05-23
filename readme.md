# MFTK

MFTK is a set of makefile functions, defined in mftk.mk, that aims to provide 
a makefile interface to enhance projects interoperability.

It does it by defining two high level concepts :
- **the makefile utility** : an utility only concerns the first execution phase of make, 
when the makefile tree is parsed.;
Based on makefile inclusion, it aims to provide build information to the 
makefile that executes it;
- **the makefile node** : a node concerns the second execution phase of make, when 
rules are called; 
Based on makefile sub-call, it aims to execute a complete step of build;

MFTK provides built-in utilities, namely :
- **cross-make** : an architecture dependent makefile inclusion utility; 
- **toolchain** : a toolchain selection utility for cross compilation;
- **arch-info** : an architecture information provider;

Both toolchain and arch_info are using cross-make.

## In brief

### Downloading MFTK

To use mftk, download the source code, and update the environment with :

```bash
git pull https://github.com/Briztal/mftk mftk
```

This will clone the project in your file system.

### Configuring MFTK

The following steps can be re-done any time you need with no restriction.

#### Search directories

You need to tell mftk where it should search for your makefile utilities and 
nodes.
To do this, add paths you want it to search in in the `search_dirs` file.
The search is of depth 1, meaning that mftk will not search recursively in the 
provided directories.

#### Environments setup

When using the cross_make utility, you must specify which environment you 
want to use.
Environments are makefile dependency trees, generated from environment 
description text files.
Environment description files are located in `internal/utils/cross_make/desc`
You are free to add and modify any environment description file. By default, 
only the arch environment is provided.

#### Update

When you have configured mftk, you must update it so your modifications are 
applied.

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

When mftk has been updated, you can use it freely.

### Including MFTK

To use mftk in one of your makefiles, include the file `mftk.mk` present in 
the project's main directory.
Your makefile will then have access to all MFTK's features, and will be able 
to execute utilities and nodes.

## Makefile key points reminder

**variables** : a variable is a makefile string containing any character except 
```=``` ```#``` or ```:```, that refers to another string.
It can be defined directly using an assignment operator (```=```,  ```?=```, 
```+=``` ...), or indirectly using keywords ```define ... endef```.
Later, it can be referred to using ```$(variable_name)```

**functions** : a function is a variable that incorporates references to arguments 
(temporary variables) ```$(1)```, ```$(2)```, etc..., that are replaced during
the expansion of the function.
It can be called using ```$(call $(func_name),arg1,arg2,...)```.

**eval** : eval must be used when the result of the expansion of a variable / 
function must be interpreted by gnu-make as makefile syntax and not just 
as variable name or content.
Any variable / function provided to eval is expanded twice : one time as text, 
and another time as makefile syntax.
Its syntax is ```$(eval $(variable_name))```, with a special reference to the 
god-blessed ```$(eval $(call func_name,arg1,arg2,...))``` that expands the 
provided function and interprets the result as makefile syntax.

## Naming policy

When dealing with sub-makes, by make sub-call or inclusion, using variables 
can get messy, as variables with temporary use may have simple name (clearly, 
try avoiding foo = 1), and make doesn't recognise the notion of context : any 
definition will override definitions with the same name.

### Namespaces

As stated earlier, makefiles variables or functions names can contain any 
character except ```=``` ```#``` or ```:```, and in particular, they can 
contain```.```.
To tackle the previous issue, as it defines multiple functions and internal 
variables, mftk uses namespaces, taking advantage of the possibility to include 
```.``` in names.
A variable will be said to be in the namespace of ```B``` (with ```B```
containing eventually one or several ```.```) if the variable has the prefix
```B.``` in its name.

The following rules are applied :
- any function / internal variable related to mftk will be in the namespace of
```mftk```;
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
all relevant arguments.

## Makefile Utility

A makefile utility is a standalone makefile, that requires arguments, and aims 
to provide any information that has a meaning in the first execution phase of 
make.
Its usage is limited to make's first phase of execution, meaning that 
using any mftk's utilities function is forbidden in a rule (first because it
makes no sense, and then because the execution would fail).

### Registration

A makefile utility is registered automatically at the initialization of mftk. 
A registered utility can't be unregistered.
At its registration, a makefile utility provides its name that must be unique
among all utilities, and the path for its entry makefile.
No utility function can be called on an unregistered utility.

### Arguments

A makefile utility receives arguments, in the form of variables with names 
that follow mftk's naming policy, that are used to control its behaviour.
For example, the toolchain utility requires the variable toolchain.target, 
providing the architecture for which the toolchain should be selected.

### Behavior

When called, a makefile utility may define variables, update variables, 
define rules, print data, include other makefiles, or do any other action 
related to make's first execution phase.
After the makefile is called, any variable in his namespace is automatically 
undefined.

### Tools

MFTK provides the following functions to deal with utilities :

Function | Description
---- | -------------
**mftk.utility.register**(util_name) | registers an utility to mftk.
**mftk.utility.require**(util_name) | fails if an utility is not registered to mftk.
**mftk.utility.define**(util_name,var_name,var_value) | defines the argument variable util_name.var_name and sets it to var_value.
**mftk.utility.execute**(util_name) | includes the utility's makefile, and undefines any argument variable defined with mftk.utility.define.

## Makefile Node

A makefile node is a standalone makefile, that requires arguments, and aims 
to execute some implementation defined build stage;
Its usage concerns both make's first and second phase of execution :
- the definition of arguments regarding on a specific execution of a node are 
made during the first phase;
- the execution of the node, consisting of a sub make call is made in the second 
phase, inside a rule;

### Registration

A makefile node is registered automatically at the initialization of mftk. 
A registered node can't be unregistered.
At its registration, a makefile node provides its name that must be unique
among all nodes, and the path for its entry makefile.
No node function can be called on an unregistered node.

### Arguments

A makefile node receives arguments, in the form of variables with names 
that follow mftk's naming policy, that are used to control its behaviour.
MFTK exports no variable, so any argument passed to a node is defined during
the sub-call to make;

In a user point of view arguments to be provided to a node are in its namespace :
a variable that must be provided to a node ```A``` has to be in the namespace 
of ```A```.
In the MFTK internals perspective, it is a little more complex.
Indeed, as stated earlier, arguments regarding on a specific make node execution 
must be defined in make's first execution stage. This means that if two 
different executions of the same node must occur, there will be two definitions
for each variable in the first phase, and of course, only the last one will 
be taken into account;


To tackle this issue, the namespace of a node argument must also contain a 
reference to the identifier of the call : a variable that must be provided 
to a node ```A``` relatively to the execution ```i``` has to be in the namespace 
of ```A.i```.
When the sub-call to make is executed, any variable in the namespace of ```A.i```
will be passed to the sub makefile, in the namespace of ```A``` 

### Behavior

A makefile node execution consists on a sub-make command targetting the makefile 
at the node's registered path;
This sub-make command is executed in its own environment, being only provided 
with its argument variables and the variable ```__MFTK__``` that refers to the 
path of MFTK's makefile;
If the node requires mftk, it must first check that mftk is provided, by testing 
if the variable ```__MFTK__``` is defined, and then using : 


```makefile
include $(__MFTK__)
```

The node being executed in a separate make call, it cannot alter the caller's
environment by any mean; No variable or rule can be provided to the caller;
For this purpose, an utility must be used;

### Tools

MFTK provides the following functions to deal with nodes :

Function | Description
---- | -------------
**mftk.node.register**(node_name) | registers a node to mftk.
**mftk.node.require**(node_name) | fails if a node is not registered to mftk.
**mftk.node.define**(node_name,call_id,var_name,var_value) | defines the variable ```node_name.call_id.var_name``` and sets it to var_value. In the node's makefile, it will be redefined and accessible as ```node_name.var_name```.
**mftk.node.execute**(node_name, call_id) | executes a sub-call to the node's makefile, providing all variables in its namespace with their proper name, then undefines any variable in the namespace ```node_name.call_id```.

