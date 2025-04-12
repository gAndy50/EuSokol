--SokolTime Wrapper
--Written by Andy P.
--OpenEuphoria wrapper for Sokol Time library
--Copyright (c) 2025

include std/ffi.e
include std/machine.e
include std/os.e

public atom sokol_time

ifdef WINDOWS then
	sokol_time = open_dll("sokol_time.dll")
	elsifdef LINUX or FREEBSD then
	sokol_time = open_dll("libsokol_time.so")
	elsifdef OSX then
	sokol_time = open_dll("libsokol_time.dylib")
end ifdef

if sokol_time = 0 then
	puts(1,"Failed to load sokoltime!\n")
	abort(0)
end if

public constant xstm_setup = define_c_proc(sokol_time,"+stm_setup",{})

public procedure stm_setup()
	c_proc(xstm_setup,{})
end procedure

public constant xstm_now = define_c_func(sokol_time,"+stm_now",{},C_UINT64)

public function stm_now()
	return c_func(xstm_now,{})
end function

public constant xstm_diff = define_c_func(sokol_time,"+stm_diff",{C_UINT64,C_UINT64},C_UINT64)

public function stm_diff(atom new_ticks,atom old_ticks)
	return c_func(xstm_diff,{new_ticks,old_ticks})
end function

public constant xstm_since = define_c_func(sokol_time,"+stm_since",{C_UINT64},C_UINT64)

public function stm_since(atom start_ticks)
	return c_func(xstm_since,{start_ticks})
end function

public constant xstm_laptime = define_c_func(sokol_time,"+stm_laptime",{C_POINTER},C_UINT64)

public function stm_laptime(atom last_time)
	return c_func(xstm_laptime,{last_time})
end function

public constant xstm_round_to_common_refresh_rate = define_c_func(sokol_time,"+stm_round_to_common_refresh_rate",{C_UINT64},C_UINT64)

public function stm_round_to_common_refresh_rate(atom frame_ticks)
	return c_func(xstm_round_to_common_refresh_rate,{frame_ticks})
end function

public constant xstm_sec = define_c_func(sokol_time,"+stm_sec",{C_UINT64},C_DOUBLE)

public function stm_sec(atom ticks)
	return c_func(xstm_sec,{ticks})
end function

public constant xstm_ms = define_c_func(sokol_time,"+stm_ms",{C_UINT64},C_DOUBLE)

public function stm_ms(atom ticks)
	return c_func(xstm_ms,{ticks})
end function

public constant xstm_us = define_c_func(sokol_time,"+stm_us",{C_UINT64},C_DOUBLE)

public function stm_us(atom ticks)
	return c_func(xstm_us,{ticks})
end function

public constant xstm_ns = define_c_func(sokol_time,"+stm_ns",{C_UINT64},C_DOUBLE)

public function stm_ns(atom ticks)
	return c_func(xstm_ns,{ticks})
end function
­30.0