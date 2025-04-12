--SokolGlue Wrapper
--Written by Andy P.
--OpenEuphoria wrapper for Sokol Glue library
--Copyright (c) 2025

include std/ffi.e
include std/machine.e
include std/os.e

public atom glue

ifdef WINDOWS then
	glue = open_dll("sokol_glue.dll")
	elsifdef LINUX or FREEBSD then
	glue = open_dll("libsokol_glue.so")
	elsifdef OSX then
	glue = open_dll("libsokol_glue.dylib")
end ifdef

if glue = 0 then
	puts(1,"Failed to load sokol_glue!\n")
	abort(0)
end if

public constant xsglue_environment = define_c_func(glue,"+sglue_environment",{},C_POINTER)

public function sglue_environment()
	return c_func(xsglue_environment,{})
end function

public constant xsglue_swapchain = define_c_func(glue,"+sglue_swapchain",{},C_POINTER)

public function sglue_swapchain()
	return c_func(xsglue_swapchain,{})
end function
­34.35