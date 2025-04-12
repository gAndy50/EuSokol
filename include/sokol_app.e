--SokolApp Wrapper
--Written by Andy P.
--OpenEuphoria wrapper for Sokol App library
--Copyright (c) 2025

include std/ffi.e
include std/machine.e
include std/os.e

public atom app

ifdef WINDOWS then
	app = open_dll("sokol_app.dll")
	elsifdef LINUX or FREEBSD then
	app = open_dll("libsokol_app.so")
	elsifdef OSX then
	app = open_dll("libsokol_app.dylib")
end ifdef

if app = 0 then
	puts(1,"Failed to load sokol_app!\n")
	abort(0)
end if

public enum SAPP_MAX_TOUCHPOINTS = 8,
    SAPP_MAX_MOUSEBUTTONS = 3,
    SAPP_MAX_KEYCODES = 512,
    SAPP_MAX_ICONIMAGES = 8
    
public enum type sapp_event_type
	SAPP_EVENTTYPE_INVALID = 0,
    SAPP_EVENTTYPE_KEY_DOWN,
    SAPP_EVENTTYPE_KEY_UP,
    SAPP_EVENTTYPE_CHAR,
    SAPP_EVENTTYPE_MOUSE_DOWN,
    SAPP_EVENTTYPE_MOUSE_UP,
    SAPP_EVENTTYPE_MOUSE_SCROLL,
    SAPP_EVENTTYPE_MOUSE_MOVE,
    SAPP_EVENTTYPE_MOUSE_ENTER,
    SAPP_EVENTTYPE_MOUSE_LEAVE,
    SAPP_EVENTTYPE_TOUCHES_BEGAN,
    SAPP_EVENTTYPE_TOUCHES_MOVED,
    SAPP_EVENTTYPE_TOUCHES_ENDED,
    SAPP_EVENTTYPE_TOUCHES_CANCELLED,
    SAPP_EVENTTYPE_RESIZED,
    SAPP_EVENTTYPE_ICONIFIED,
    SAPP_EVENTTYPE_RESTORED,
    SAPP_EVENTTYPE_FOCUSED,
    SAPP_EVENTTYPE_UNFOCUSED,
    SAPP_EVENTTYPE_SUSPENDED,
    SAPP_EVENTTYPE_RESUMED,
    SAPP_EVENTTYPE_QUIT_REQUESTED,
    SAPP_EVENTTYPE_CLIPBOARD_PASTED,
    SAPP_EVENTTYPE_FILES_DROPPED,
    _SAPP_EVENTTYPE_NUM,
    _SAPP_EVENTTYPE_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sapp_keycode
	SAPP_KEYCODE_INVALID          = 0,
    SAPP_KEYCODE_SPACE            = 32,
    SAPP_KEYCODE_APOSTROPHE       = 39, -- /* ' */
    SAPP_KEYCODE_COMMA            = 44, -- /* , */
    SAPP_KEYCODE_MINUS            = 45, -- /* - */
    SAPP_KEYCODE_PERIOD           = 46, -- /* . */
    SAPP_KEYCODE_SLASH            = 47, -- /* / */
    SAPP_KEYCODE_0                = 48,
    SAPP_KEYCODE_1                = 49,
    SAPP_KEYCODE_2                = 50,
    SAPP_KEYCODE_3                = 51,
    SAPP_KEYCODE_4                = 52,
    SAPP_KEYCODE_5                = 53,
    SAPP_KEYCODE_6                = 54,
    SAPP_KEYCODE_7                = 55,
    SAPP_KEYCODE_8                = 56,
    SAPP_KEYCODE_9                = 57,
    SAPP_KEYCODE_SEMICOLON        = 59, -- /* ; */
    SAPP_KEYCODE_EQUAL            = 61, -- /* = */
    SAPP_KEYCODE_A                = 65,
    SAPP_KEYCODE_B                = 66,
    SAPP_KEYCODE_C                = 67,
    SAPP_KEYCODE_D                = 68,
    SAPP_KEYCODE_E                = 69,
    SAPP_KEYCODE_F                = 70,
    SAPP_KEYCODE_G                = 71,
    SAPP_KEYCODE_H                = 72,
    SAPP_KEYCODE_I                = 73,
    SAPP_KEYCODE_J                = 74,
    SAPP_KEYCODE_K                = 75,
    SAPP_KEYCODE_L                = 76,
    SAPP_KEYCODE_M                = 77,
    SAPP_KEYCODE_N                = 78,
    SAPP_KEYCODE_O                = 79,
    SAPP_KEYCODE_P                = 80,
    SAPP_KEYCODE_Q                = 81,
    SAPP_KEYCODE_R                = 82,
    SAPP_KEYCODE_S                = 83,
    SAPP_KEYCODE_T                = 84,
    SAPP_KEYCODE_U                = 85,
    SAPP_KEYCODE_V                = 86,
    SAPP_KEYCODE_W                = 87,
    SAPP_KEYCODE_X                = 88,
    SAPP_KEYCODE_Y                = 89,
    SAPP_KEYCODE_Z                = 90,
    SAPP_KEYCODE_LEFT_BRACKET     = 91, -- /* [ */
    SAPP_KEYCODE_BACKSLASH        = 92, -- /* \ */
    SAPP_KEYCODE_RIGHT_BRACKET    = 93, -- /* ] */
    SAPP_KEYCODE_GRAVE_ACCENT     = 96, -- /* ` */
    SAPP_KEYCODE_WORLD_1          = 161, -- /* non-US #1 */
    SAPP_KEYCODE_WORLD_2          = 162, --/* non-US #2 */
    SAPP_KEYCODE_ESCAPE           = 256,
    SAPP_KEYCODE_ENTER            = 257,
    SAPP_KEYCODE_TAB              = 258,
    SAPP_KEYCODE_BACKSPACE        = 259,
    SAPP_KEYCODE_INSERT           = 260,
    SAPP_KEYCODE_DELETE           = 261,
    SAPP_KEYCODE_RIGHT            = 262,
    SAPP_KEYCODE_LEFT             = 263,
    SAPP_KEYCODE_DOWN             = 264,
    SAPP_KEYCODE_UP               = 265,
    SAPP_KEYCODE_PAGE_UP          = 266,
    SAPP_KEYCODE_PAGE_DOWN        = 267,
    SAPP_KEYCODE_HOME             = 268,
    SAPP_KEYCODE_END              = 269,
    SAPP_KEYCODE_CAPS_LOCK        = 280,
    SAPP_KEYCODE_SCROLL_LOCK      = 281,
    SAPP_KEYCODE_NUM_LOCK         = 282,
    SAPP_KEYCODE_PRINT_SCREEN     = 283,
    SAPP_KEYCODE_PAUSE            = 284,
    SAPP_KEYCODE_F1               = 290,
    SAPP_KEYCODE_F2               = 291,
    SAPP_KEYCODE_F3               = 292,
    SAPP_KEYCODE_F4               = 293,
    SAPP_KEYCODE_F5               = 294,
    SAPP_KEYCODE_F6               = 295,
    SAPP_KEYCODE_F7               = 296,
    SAPP_KEYCODE_F8               = 297,
    SAPP_KEYCODE_F9               = 298,
    SAPP_KEYCODE_F10              = 299,
    SAPP_KEYCODE_F11              = 300,
    SAPP_KEYCODE_F12              = 301,
    SAPP_KEYCODE_F13              = 302,
    SAPP_KEYCODE_F14              = 303,
    SAPP_KEYCODE_F15              = 304,
    SAPP_KEYCODE_F16              = 305,
    SAPP_KEYCODE_F17              = 306,
    SAPP_KEYCODE_F18              = 307,
    SAPP_KEYCODE_F19              = 308,
    SAPP_KEYCODE_F20              = 309,
    SAPP_KEYCODE_F21              = 310,
    SAPP_KEYCODE_F22              = 311,
    SAPP_KEYCODE_F23              = 312,
    SAPP_KEYCODE_F24              = 313,
    SAPP_KEYCODE_F25              = 314,
    SAPP_KEYCODE_KP_0             = 320,
    SAPP_KEYCODE_KP_1             = 321,
    SAPP_KEYCODE_KP_2             = 322,
    SAPP_KEYCODE_KP_3             = 323,
    SAPP_KEYCODE_KP_4             = 324,
    SAPP_KEYCODE_KP_5             = 325,
    SAPP_KEYCODE_KP_6             = 326,
    SAPP_KEYCODE_KP_7             = 327,
    SAPP_KEYCODE_KP_8             = 328,
    SAPP_KEYCODE_KP_9             = 329,
    SAPP_KEYCODE_KP_DECIMAL       = 330,
    SAPP_KEYCODE_KP_DIVIDE        = 331,
    SAPP_KEYCODE_KP_MULTIPLY      = 332,
    SAPP_KEYCODE_KP_SUBTRACT      = 333,
    SAPP_KEYCODE_KP_ADD           = 334,
    SAPP_KEYCODE_KP_ENTER         = 335,
    SAPP_KEYCODE_KP_EQUAL         = 336,
    SAPP_KEYCODE_LEFT_SHIFT       = 340,
    SAPP_KEYCODE_LEFT_CONTROL     = 341,
    SAPP_KEYCODE_LEFT_ALT         = 342,
    SAPP_KEYCODE_LEFT_SUPER       = 343,
    SAPP_KEYCODE_RIGHT_SHIFT      = 344,
    SAPP_KEYCODE_RIGHT_CONTROL    = 345,
    SAPP_KEYCODE_RIGHT_ALT        = 346,
    SAPP_KEYCODE_RIGHT_SUPER      = 347,
    SAPP_KEYCODE_MENU             = 348
end type

public enum type sapp_android_tooltype
	SAPP_ANDROIDTOOLTYPE_UNKNOWN = 0,  -- // TOOL_TYPE_UNKNOWN
    SAPP_ANDROIDTOOLTYPE_FINGER = 1,   -- // TOOL_TYPE_FINGER
    SAPP_ANDROIDTOOLTYPE_STYLUS = 2,   -- // TOOL_TYPE_STYLUS
    SAPP_ANDROIDTOOLTYPE_MOUSE = 3    -- // TOOL_TYPE_MOUSE
end type

public constant sapp_touchpoint = define_c_struct({
	C_POINTER, --identifier
	C_FLOAT, --pos_x
	C_FLOAT, --pos_y
	C_INT, --android_tooltype
	C_BOOL --changed
})

public enum type sapp_mousebutton
	SAPP_MOUSEBUTTON_LEFT = 0x0,
    SAPP_MOUSEBUTTON_RIGHT = 0x1,
    SAPP_MOUSEBUTTON_MIDDLE = 0x2,
    SAPP_MOUSEBUTTON_INVALID = 0x100
end type

public enum  SAPP_MODIFIER_SHIFT = 0x1,     -- // left or right shift key
    SAPP_MODIFIER_CTRL  = 0x2,     -- // left or right control key
    SAPP_MODIFIER_ALT   = 0x4,      --// left or right alt key
    SAPP_MODIFIER_SUPER = 0x8,      --// left or right 'super' key
    SAPP_MODIFIER_LMB   = 0x100,    --// left mouse button
    SAPP_MODIFIER_RMB   = 0x200,    --// right mouse button
    SAPP_MODIFIER_MMB   = 0x400    --// middle mouse button
    
public constant sapp_event = define_c_struct({
	C_UINT64, --frame_count
	C_INT, --event type
	C_INT, --key_code
	C_UINT32, --char_mode
	C_BOOL, --key_repeat
	C_UINT32, --modifiers
	C_INT, --mouse_button
	C_FLOAT, --mouse_x
	C_FLOAT, --mouse_y
	C_FLOAT, --mouse_dx
	C_FLOAT, --mouse_dy
	C_FLOAT, --scroll_x
	C_FLOAT, --scroll_y
	C_INT, --num_touches
	{sapp_touchpoint,SAPP_MAX_TOUCHPOINTS}, --touches
	C_INT, --window_width
	C_INT, --window_height
	C_INT, --framebuffer_width
	C_INT --framebuffer_height
})

public constant sapp_range = define_c_struct({
	C_POINTER, --ptr
	C_SIZE_T --size
})

public constant sapp_image_desc = define_c_struct({
	C_INT, --width
	C_INT, --height
	sapp_range --pixels
})

public constant sapp_icon_desc = define_c_struct({
	C_BOOL, --sokol_default
	{sapp_image_desc,SAPP_MAX_ICONIMAGES}
})

public constant sapp_allocator = define_c_struct({
	C_POINTER, --alloc_fn
	C_SIZE_T, --size
	C_POINTER, --user_data
	C_POINTER, --fre_fn
	C_POINTER, --ptr
	C_POINTER, --user_data
	C_POINTER --user_data
})

public constant sapp_logger = define_c_struct({
	C_POINTER, --func
	C_STRING, --tag
	C_UINT32, --log_level
	C_UINT32, --log_item_id
	C_STRING, --message_or_nul
	C_UINT32, --line_nr
	C_STRING, --filename_or_null
	C_POINTER, --user_data
	C_POINTER --user_data
})

public constant sapp_desc = define_c_struct({
	C_POINTER, --init_cb
	C_POINTER, --frame_cb
	C_POINTER, --cleanup_cb
	C_POINTER, --event_cb
	C_POINTER, --sapp_event
	C_POINTER, --user_data
	C_POINTER, --init_userdata_cb
	C_POINTER, --frame_userdata_cb
	C_POINTER, --cleanup_userdata_cb
	C_POINTER, --event_userdata_cb
	C_POINTER, --sappevent
	
	C_INT, --width
	C_INT, --height
	C_INT, --sample_count
	C_INT, --swap_interval
	C_BOOL, --high_dpi
	C_BOOL, --fullscreen
	C_BOOL, --alpha
	C_STRING, --window_title
	C_BOOL, --enable_clipboard
	C_INT, --clipboard_size
	C_BOOL, --enable_dragndrop
	C_INT, --max_dropped_files
	C_INT, --max_drooped_file_path_length
	sapp_icon_desc, --icon
	sapp_allocator, --allocator
	sapp_logger, --logger
	
	C_INT, --gl_major_version
	C_INT, --gl_minor_version
	C_BOOL, --win32_console_utf8
	C_BOOL, --win32_console_create
	C_BOOL, --win32_console_attach
	C_STRING, --html5_canvas_selector
	C_BOOL, --html5_canvas_resize
	C_BOOL, --html5_preserve_drawing_buffer
	C_BOOL, --html5_premultiplied_alpha
	C_BOOL, --html5_ask_leave_site
	C_BOOL, --html5_update_document_title
	C_BOOL, --html5_bubble_mouse_events
	C_BOOL, --html5_bubble_touch_events
	C_BOOL, --html5_bubble_wheel_events
	C_BOOL, --html5_bubble_key_events
	C_BOOL, --html5_bubble_char_events
	C_BOOL, --html5_use_emsc_set_main_loop
	C_BOOL, --html5_emsc_set_main_loop_simulate_inifinte_loop
	C_BOOL  --ios_keyboard_resizes_canvas
})

public enum type sapp_html5_fetch_error
	SAPP_HTML5_FETCH_ERROR_NO_ERROR = 0,
    SAPP_HTML5_FETCH_ERROR_BUFFER_TOO_SMALL,
    SAPP_HTML5_FETCH_ERROR_OTHE
end type

public constant sapp_html5_fetch_response = define_c_struct({
	C_BOOL, --succeeded
	C_INT, --error_code
	C_INT, --file_index
	sapp_range, --data
	sapp_range, --buffer
	C_POINTER --user_data
})

public constant sapp_html5_fetch_request = define_c_struct({
	C_INT, --dropped_file_index
	C_POINTER,C_POINTER, --callback,sapp_html5_fetch_responde
	sapp_range, --buffer
	C_POINTER --user_data
})

public enum type sapp_mouse_cursor
	SAPP_MOUSECURSOR_DEFAULT = 0,  -- // equivalent with system default cursor
    SAPP_MOUSECURSOR_ARROW,
    SAPP_MOUSECURSOR_IBEAM,
    SAPP_MOUSECURSOR_CROSSHAIR,
    SAPP_MOUSECURSOR_POINTING_HAND,
    SAPP_MOUSECURSOR_RESIZE_EW,
    SAPP_MOUSECURSOR_RESIZE_NS,
    SAPP_MOUSECURSOR_RESIZE_NWSE,
    SAPP_MOUSECURSOR_RESIZE_NESW,
    SAPP_MOUSECURSOR_RESIZE_ALL,
    SAPP_MOUSECURSOR_NOT_ALLOWED,
    _SAPP_MOUSECURSOR_NUM
end type

public constant xsokol_main = define_c_func(app,"+sokol_main",{C_INT,C_POINTER},sapp_desc)

public function sokol_main(atom argc,object argv)
	return c_func(xsokol_main,{argc,argv})
end function

public constant xsapp_isvalid = define_c_func(app,"+sapp_isvalid",{},C_BOOL)

public function sapp_isvalid()
	return c_func(xsapp_isvalid,{})
end function

public constant xsapp_width = define_c_func(app,"+sapp_width",{},C_INT)

public function sapp_width()
	return c_func(xsapp_width,{})
end function

public constant xsapp_widthf = define_c_func(app,"+sapp_widthf",{},C_FLOAT)

public function sapp_widthf()
	return c_func(xsapp_widthf,{})
end function

public constant xsapp_height = define_c_func(app,"+sapp_height",{},C_INT)

public function sapp_height()
	return c_func(xsapp_height,{})
end function

public constant xsapp_heightf = define_c_func(app,"+sapp_heightf",{},C_FLOAT)

public function sapp_heightf()
	return c_func(xsapp_heightf,{})
end function

public constant xsapp_color_format = define_c_func(app,"+sapp_color_format",{},C_INT)

public function sapp_color_format()
	return c_func(xsapp_color_format,{})
end function

public constant xsapp_depth_format = define_c_func(app,"+sapp_depth_format",{},C_INT)

public function sapp_depth_format()
	return c_func(xsapp_depth_format,{})
end function

public constant xsapp_sample_count = define_c_func(app,"+sapp_sample_count",{},C_INT)

public function sapp_sample_count()
	return c_func(xsapp_sample_count,{})
end function

public constant xsapp_high_dpi = define_c_func(app,"+sapp_high_dpi",{},C_BOOL)

public function sapp_high_dpi()
	return c_func(xsapp_high_dpi,{})
end function

public constant xsapp_dpi_scale = define_c_func(app,"+sapp_dpi_scale",{},C_FLOAT)

public function sapp_dpi_scale()
	return c_func(xsapp_dpi_scale,{})
end function

public constant xsapp_show_keyboard = define_c_proc(app,"+sapp_show_keyboard",{C_BOOL})

public procedure sapp_show_keyboard(atom show)
	c_proc(xsapp_show_keyboard,{show})
end procedure

public constant xsapp_keyboard_shown = define_c_func(app,"+sapp_keyboard_shown",{},C_BOOL)

public function sapp_keyboard_shown()
	return c_func(xsapp_keyboard_shown,{})
end function

public constant xsapp_is_fullscreen = define_c_func(app,"+sapp_is_fullscreen",{},C_BOOL)

public function sapp_is_fullscreen()
	return c_func(xsapp_is_fullscreen,{})
end function

public constant xsapp_toggle_fullscreen = define_c_proc(app,"+sapp_toggle_fullscreen",{})

public procedure sapp_toggle_fullscreen()
	c_proc(xsapp_toggle_fullscreen,{})
end procedure

public constant xsapp_show_mouse = define_c_proc(app,"+sapp_show_mouse",{C_BOOL})

public procedure sapp_show_mouse(atom show)
	c_proc(xsapp_show_mouse,{show})
end procedure

public constant xsapp_mouse_shown = define_c_func(app,"+sapp_mouse_shown",{},C_BOOL)

public function sapp_mouse_shown()
	return c_func(xsapp_mouse_shown,{})
end function

public constant xsapp_lock_mouse = define_c_proc(app,"+sapp_lock_mouse",{C_BOOL})

public procedure sapp_lock_mouse(atom lock)
	c_proc(xsapp_lock_mouse,{lock})
end procedure

public constant xsapp_mouse_locked = define_c_func(app,"+sapp_mouse_locked",{},C_BOOL)

public function sapp_mouse_locked()
	return c_func(xsapp_mouse_locked,{})
end function

public constant xsapp_set_mouse_cursor = define_c_proc(app,"+sapp_set_mouse_cursor",{C_INT})

public procedure sapp_set_mouse_cursor(atom cursor)
	c_proc(xsapp_set_mouse_cursor,{cursor})
end procedure

public constant xsapp_get_mouse_cursor = define_c_func(app,"+sapp_get_mouse_cursor",{},C_INT)

public function sapp_get_mouse_cursor()
	return c_func(xsapp_get_mouse_cursor,{})
end function

public constant xsapp_userdata = define_c_func(app,"+sapp_userdata",{},C_POINTER)

public function sapp_userdata()
	return c_func(xsapp_userdata,{})
end function

public constant xsapp_query_desc = define_c_func(app,"+sapp_query_desc",{},sapp_desc)

public function sapp_query_desc()
	return c_func(xsapp_query_desc,{})
end function

public constant xsapp_request_quit = define_c_proc(app,"+sapp_request_quit",{})

public procedure sapp_request_quit()
	c_proc(xsapp_request_quit,{})
end procedure

public constant xsapp_cancel_quit = define_c_proc(app,"+sapp_cancel_quit",{})

public procedure sapp_cancel_quit()
	c_proc(xsapp_cancel_quit,{})
end procedure

public constant xsapp_quit = define_c_proc(app,"+sapp_quit",{})

public procedure sapp_quit()
	c_proc(xsapp_quit,{})
end procedure

public constant xsapp_consume_event = define_c_proc(app,"+sapp_consume_event",{})

public procedure sapp_consume_event()
	c_proc(xsapp_consume_event,{})
end procedure

public constant xsapp_frame_count = define_c_func(app,"+sapp_frame_count",{},C_UINT64)

public function sapp_frame_count()
	return c_func(xsapp_frame_count,{})
end function

public constant xsapp_frame_duration = define_c_func(app,"+sapp_frame_duration",{},C_DOUBLE)

public function sapp_frame_duration()
	return c_func(xsapp_frame_duration,{})
end function

public constant xsapp_set_clipboard_string = define_c_proc(app,"+sapp_set_clipboard_string",{C_STRING})

public procedure sapp_set_clipboard_string(sequence str)
	c_proc(xsapp_set_clipboard_string,{str})
end procedure

public constant xsapp_get_clipboard_string = define_c_func(app,"+sapp_get_clipboard_string",{},C_STRING)

public function sapp_get_clipboard_string()
	return c_func(xsapp_get_clipboard_string,{})
end function

public constant xsapp_set_window_title = define_c_proc(app,"+sapp_set_window_title",{C_STRING})

public procedure sapp_set_window_title(sequence str)
	c_proc(xsapp_set_window_title,{str})
end procedure

public constant xsapp_set_icon = define_c_proc(app,"+sapp_set_icon",{C_POINTER})

public procedure sapp_set_icon(atom icon_desc)
	c_proc(xsapp_set_icon,{icon_desc})
end procedure

public constant xsapp_get_num_dropped_files = define_c_func(app,"+sapp_get_num_dropped_files",{},C_INT)

public function sapp_get_num_dropped_files()
	return c_func(xsapp_get_num_dropped_files,{})
end function

public constant xsapp_get_dropped_file_path = define_c_func(app,"+sapp_get_dropped_file_path",{C_INT},C_STRING)

public function sapp_get_dropped_file_path(atom index)
	return c_func(xsapp_get_dropped_file_path,{index})
end function

public constant xsapp_run = define_c_proc(app,"+sapp_run",{C_POINTER})

public procedure sapp_run(atom desc)
	c_proc(xsapp_run,{desc})
end procedure

public constant xsapp_egl_get_display = define_c_func(app,"+sapp_egl_get_display",{},C_POINTER)

public function sapp_egl_get_display()
	return c_func(xsapp_egl_get_display,{})
end function

public constant xsapp_egl_get_context = define_c_func(app,"+sapp_egl_get_context",{},C_POINTER)

public function sapp_egl_get_context()
	return c_func(xsapp_egl_get_context,{})
end function

public constant xsapp_html5_ask_leave_site = define_c_proc(app,"+sapp_html5_ask_leave_site",{C_BOOL})

public procedure sapp_html5_ask_leave_site(atom ask)
	c_proc(xsapp_html5_ask_leave_site,{ask})
end procedure

public constant xsapp_html5_get_dropped_file_size = define_c_func(app,"+sapp_html5_get_dropped_file_size",{C_INT},C_UINT32)

public function sapp_html5_get_dropped_file_size(atom index)
	return c_func(xsapp_html5_get_dropped_file_size,{index})
end function

public constant xsapp_html5_fetch_dropped_file = define_c_proc(app,"+sapp_html5_fetch_dropped_file",{C_POINTER})

public procedure sapp_html5_fetch_dropped_file(atom request)
	c_proc(xsapp_html5_fetch_dropped_file,{request})
end procedure

public constant xsapp_metal_get_device = define_c_func(app,"+sapp_metal_get_device",{},C_POINTER)

public function sapp_metal_get_device()
	return c_func(xsapp_metal_get_device,{})
end function

public constant xsapp_metal_get_current_drawable = define_c_func(app,"+sapp_metal_get_current_drawable",{},C_POINTER)

public function sapp_metal_get_current_drawable()
	return c_func(xsapp_metal_get_current_drawable,{})
end function

public constant xsapp_metal_get_depth_stencil_texture = define_c_func(app,"+sapp_metal_get_depth_stencil_texture",{},C_POINTER)

public function sapp_metal_get_depth_stencil_texture()
	return c_func(xsapp_metal_get_depth_stencil_texture,{})
end function

public constant xsapp_metal_get_msaa_color_texture = define_c_func(app,"+sapp_metal_get_msaa_color_texture",{},C_POINTER)

public function sapp_metal_get_msaa_color_texture()
	return c_func(xsapp_metal_get_msaa_color_texture,{})
end function

public constant xsapp_macos_get_window = define_c_func(app,"+sapp_macos_get_window",{},C_POINTER)

public function sapp_macos_get_window()
	return c_func(xsapp_macos_get_window,{})
end function

public constant xsapp_ios_get_window = define_c_func(app,"+sapp_ios_get_window",{},C_POINTER)

public function sapp_ios_get_window()
	return c_func(xsapp_ios_get_window,{})
end function

public constant xsapp_d3d11_get_device = define_c_func(app,"+sapp_d3d11_get_device",{},C_POINTER)

public function sapp_d3d11_get_device()
	return c_func(xsapp_d3d11_get_device,{})
end function

public constant xsapp_d3d11_get_device_context = define_c_func(app,"+sapp_d3d11_get_device_context",{},C_POINTER)

public function sapp_d3d11_get_device_context()
	return c_func(xsapp_d3d11_get_device_context,{})
end function

public constant xsapp_d3d11_get_swap_chain = define_c_func(app,"+sapp_d3d11_get_swap_chain",{},C_POINTER)

public function sapp_d3d11_get_swap_chain()
	return c_func(xsapp_d3d11_get_swap_chain,{})
end function

public constant xsapp_d3d11_get_render_view = define_c_func(app,"+sapp_d3d11_get_render_view",{},C_POINTER)

public function sapp_d3d11_get_render_view()
	return c_func(xsapp_d3d11_get_render_view,{})
end function

public constant xsapp_d3d11_get_resolve_view = define_c_func(app,"+sapp_d3d11_get_resolve_view",{},C_POINTER)

public function sapp_d3d11_get_resolve_view()
	return c_func(xsapp_d3d11_get_resolve_view,{})
end function

public constant xsapp_d3d11_get_depth_stencil_view = define_c_func(app,"+sapp_d3d11_get_depth_stencil_view",{},C_POINTER)

public function sapp_d3d11_get_depth_stencil_view()
	return c_func(xsapp_d3d11_get_depth_stencil_view,{})
end function

public constant xsapp_win32_get_hwnd = define_c_func(app,"+sapp_win32_get_hwnd",{},C_POINTER)

public function sapp_win32_get_hwnd()
	return c_func(xsapp_win32_get_hwnd,{})
end function

public constant xsapp_wgpu_get_device = define_c_func(app,"+sapp_wgpu_get_device",{},C_POINTER)

public function sapp_wgpu_get_device()
	return c_func(xsapp_wgpu_get_device,{})
end function

public constant xsapp_wgpu_get_render_view = define_c_func(app,"+sapp_wgpu_get_render_view",{},C_POINTER)

public function sapp_wgpu_get_render_view()
	return c_func(xsapp_wgpu_get_render_view,{})
end function

public constant xsapp_wgpu_get_resolve_view = define_c_func(app,"+sapp_wgpu_get_resolve_view",{},C_POINTER)

public function sapp_wgpu_get_resolve_view()
	return c_func(xsapp_wgpu_get_resolve_view,{})
end function

public constant xsapp_wgpu_get_depth_stencil_view = define_c_func(app,"+sapp_wgpu_get_depth_stencil_view",{},C_POINTER)

public function sapp_wgpu_get_depth_stencil_view()
	return c_func(xsapp_wgpu_get_depth_stencil_view,{})
end function

public constant xsapp_gl_get_framebuffer = define_c_func(app,"+sapp_gl_get_framebuffer",{},C_UINT32)

public function sapp_gl_get_framebuffer()
	return c_func(xsapp_gl_get_framebuffer,{})
end function

public constant xsapp_gl_get_major_version = define_c_func(app,"+sapp_gl_get_major_version",{},C_INT)

public function sapp_gl_get_major_version()
	return c_func(xsapp_gl_get_major_version,{})
end function

public constant xsapp_gl_get_minor_version = define_c_func(app,"+sapp_gl_get_minor_version",{},C_INT)

public function sapp_gl_get_minor_version()
	return c_func(xsapp_gl_get_minor_version,{})
end function

public constant xsapp_gl_is_gles = define_c_func(app,"+sapp_gl_is_gles",{},C_BOOL)

public function sapp_gl_is_gles()
	return c_func(xsapp_gl_is_gles,{})
end function

public constant xsapp_x11_get_window = define_c_func(app,"+sapp_x11_get_window",{},C_POINTER)

public function sapp_x11_get_window()
	return c_func(xsapp_x11_get_window,{})
end function

public constant xsapp_x11_get_display = define_c_func(app,"+sapp_x11_get_display",{},C_POINTER)

public function sapp_x11_get_display()
	return c_func(xsapp_x11_get_display,{})
end function

public constant xsapp_android_get_native_activity = define_c_func(app,"+sapp_android_get_native_activity",{},C_POINTER)

public function sapp_android_get_native_activity()
	return c_func(xsapp_android_get_native_activity,{})
end function
­667.60