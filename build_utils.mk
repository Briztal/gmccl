
$(eval $(call UTIL_REGISTER,cross_make,$(__MFTK_RDIR__)/utils/cross_make/cross_make.mk))

$(eval $(call UTIL_REGISTER,arch_info,$(__MFTK_RDIR__)/utils/arch_info/arch_info.mk))

$(eval $(call UTIL_REGISTER,toolchain,$(__MFTK_RDIR__)/utils/toolchain/toolchain.mk))
