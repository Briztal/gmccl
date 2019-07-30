
#-------------------------------------------------------------- x86 architecture

#x86 root architecture. DOES NOT REFER TO 32 bits x86, see x8632 for this.
_a.x86 :=

#32 and 64 bits x86 architectures.
_a.x8632 := x86
_a.x8664 := x86

#-------------------------------------------------------------- arm architecture

#arm32 root architecture.
_a.arm32 :=

#armv32 architectures.
_a.armv6m := arm32
_a.armv6 := arm32
_a.armv7m := arm32
_a.armv7 := arm32
_a.armv8m := arm32
_a.armv8 := arm32

#---------------------------------------------------------------- arm processors

#The cortex M processors.
_a.cortexm4f := armv7m
_a.cortexm4 := armv7m
_a.cortexm3 := armv7m
_a.cortexm1 := armv7m
_a.cortexm0p := armv7m
_a.cortexm0 := armv7m

#------------------------------------------------------------------ nxp families

#Kinetis families
_a.kinetiskl :=
_a.kinetisk := kinetiskl
_a.kinetisk := kinetiskl

#--------------------------------------------------------------------- nxp chips

#Kinetis K chips
_a.k64fx512 := kinetisk cortexm4f

#------------------------------------------------------------------ other boards

#PJRC boards
_a.teensy35 := k64fx512


