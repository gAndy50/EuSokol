--SokolAudio Wrapper
--Written by Andy P.
--OpenEuphoria wrapper for Sokol Audio library
--Copyright (c) 2025

include std/ffi.e
include std/machine.e
include std/os.e

public atom aud

ifdef WINDOWS then
	aud = open_dll("sokol_audio.dll")
	elsifdef LINUX or FREEBSD then
	aud = open_dll("libsokol_audio.so")
	elsifdef OSX then
	aud = open_dll("libsokol_audio.dylib")
end ifdef

if aud = 0 then
	puts(1,"Failed to load sokol_audio!\n")
	abort(0)
end if

public constant saudio_logger = define_c_struct({
	C_POINTER, --func
	C_STRING, --tag
	C_UINT32, --log_level
	C_UINT32, --log_item_id
	C_STRING, --message_or_null
	C_UINT32, --line_nr
	C_STRING, --filename_or_null
	C_POINTER, --user_data
	C_POINTER --user_data
})

public constant saudio_allocator = define_c_struct({
	C_POINTER, --alloc_fn
	C_SIZE_T, --size
	C_POINTER, --user_data
	C_POINTER, --free_fn
	C_POINTER, --ptr
	C_POINTER, --user_data
	C_POINTER --user_data
})

public constant saudio_desc = define_c_struct({
	C_INT, --sample_rate
	C_INT, --num_channels
	C_INT, --buffer_frames
	C_INT, --packet_frames
	C_INT, --num_packets
	C_POINTER, --stream_cb
	C_POINTER, --stream_userdata_cb
	C_POINTER, --userdata
	saudio_allocator, --allocator
	saudio_logger --logger
})

public constant xsaudio_setup = define_c_proc(aud,"+saudio_setup",{C_POINTER})

public procedure saudio_setup(atom desc)
	c_proc(xsaudio_setup,{desc})
end procedure

public constant xsaudio_shutdown = define_c_proc(aud,"+saudio_shutdown",{})

public procedure saudio_shutdown()
	c_proc(xsaudio_shutdown,{})
end procedure

public constant xsaudio_isvalid = define_c_func(aud,"+saudio_isvalid",{},C_BOOL)

public function saudio_isvalid()
	return c_func(xsaudio_isvalid,{})
end function

public constant xsaudio_userdata = define_c_func(aud,"+saudio_userdata",{},C_POINTER)

public function saudio_userdata()
	return c_func(xsaudio_userdata,{})
end function

public constant xsaudio_query_desc = define_c_func(aud,"+saudio_query_desc",{},saudio_desc)

public function saudio_query_desc()
	return c_func(xsaudio_query_desc,{})
end function

public constant xsaudio_sample_rate = define_c_func(aud,"+saudio_sample_rate",{},C_INT)

public function saudio_sample_rate()
	return c_func(xsaudio_sample_rate,{})
end function

public constant xsaudio_buffer_frames = define_c_func(aud,"+saudio_buffer_frames",{},C_INT)

public function saudio_buffer_frames()
	return c_func(xsaudio_buffer_frames,{})
end function

public constant xsaudio_channels = define_c_func(aud,"+saudio_channels",{},C_INT)

public function saudio_channels()
	return c_func(xsaudio_channels,{})
end function

public constant xsaudio_suspended = define_c_func(aud,"+saudio_suspended",{},C_BOOL)

public function saudio_suspended()
	return c_func(xsaudio_suspended,{})
end function

public constant xsaudio_expect = define_c_func(aud,"+saudio_expect",{},C_INT)

public function saudio_expect()
	return c_func(xsaudio_expect,{})
end function

public constant xsaudio_push = define_c_func(aud,"+saudio_push",{C_POINTER,C_INT},C_INT)

public function saudio_push(atom frames,atom num_frames)
	return c_func(xsaudio_push,{frames,num_frames})
end function
­1.0