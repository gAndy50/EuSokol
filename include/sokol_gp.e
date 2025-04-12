--SokolGP Wrapper
--Written by Andy P.
--OpenEuphoria wrapper for Sokol GP library
--Copyright (c) 2025

include std/ffi.e
include std/machine.e
include std/os.e

public atom gp

ifdef WINDOWS then
	gp = open_dll("sokol_gp.dll")
	elsifdef LINUX or FREEBSD then
	gp = open_dll("libsokol_gp.so")
	elsifdef OSX then
	gp = open_dll("libsokol_gp.dylib")
end ifdef

if gp = 0 then
	puts(1,"Failed to load sokol_gp!\n")
	abort(0)
end if

public constant SOKOL_GP_INCLUDED = 1

public constant SGP_BATCH_OPTIMIZER_DEPTH = 8

public constant SGP_UNIFORM_CONTENT_SLOTS = 8

public constant SGP_TEXTURE_SLOTS = 4

include sokol_gfx.e

public enum type sgp_error
	SGP_NO_ERROR = 0,
    SGP_ERROR_SOKOL_INVALID,
    SGP_ERROR_VERTICES_FULL,
    SGP_ERROR_UNIFORMS_FULL,
    SGP_ERROR_COMMANDS_FULL,
    SGP_ERROR_VERTICES_OVERFLOW,
    SGP_ERROR_TRANSFORM_STACK_OVERFLOW,
    SGP_ERROR_TRANSFORM_STACK_UNDERFLOW,
    SGP_ERROR_STATE_STACK_OVERFLOW,
    SGP_ERROR_STATE_STACK_UNDERFLOW,
    SGP_ERROR_ALLOC_FAILED,
    SGP_ERROR_MAKE_VERTEX_BUFFER_FAILED,
    SGP_ERROR_MAKE_WHITE_IMAGE_FAILED,
    SGP_ERROR_MAKE_NEAREST_SAMPLER_FAILED,
    SGP_ERROR_MAKE_COMMON_SHADER_FAILED,
    SGP_ERROR_MAKE_COMMON_PIPELINE_FAILED
end type

public enum type sgp_blend_mode
	 SGP_BLENDMODE_NONE = 0,      --         /* No blending
                                   --          dstRGBA = srcRGBA */
    SGP_BLENDMODE_BLEND,            --      /* Alpha blending.
                                    --         dstRGB = (srcRGB * srcA) + (dstRGB * (1-srcA))
                                            -- dstA = srcA + (dstA * (1-srcA)) */
    SGP_BLENDMODE_BLEND_PREMULTIPLIED, --   /* Pre-multiplied alpha blending.
                                        --     dstRGBA = srcRGBA + (dstRGBA * (1-srcA)) */
    SGP_BLENDMODE_ADD,                  --  /* Additive blending.
                                         --    dstRGB = (srcRGB * srcA) + dstRGB
                                          --   dstA = dstA */
    SGP_BLENDMODE_ADD_PREMULTIPLIED,     -- /* Pre-multiplied additive blending.
                                          --   dstRGB = srcRGB + dstRGB
                                          --   dstA = dstA */
    SGP_BLENDMODE_MOD,                    --/* Color modulate.
                                           --  dstRGB = srcRGB * dstRGB
                                            -- dstA = dstA */
    SGP_BLENDMODE_MUL,                   -- /* Color multiply.
                                          --   dstRGB = (srcRGB * dstRGB) + (dstRGB * (1-srcA))
                                           --  dstA = (srcA * dstA) + (dstA * (1-srcA)) */
    _SGP_BLENDMODE_NUM
end type

public enum type sgp_vs_attr_location
	SGP_VS_ATTR_COORD = 0,
    SGP_VS_ATTR_COLOR = 1
end type

public enum type sgp_uniform_slot
	SGP_UNIFORM_SLOT_VERTEX = 0,
    SGP_UNIFORM_SLOT_FRAGMENT = 1
end type

public constant sgp_isize = define_c_struct({
	C_INT, --w
	C_INT --h
})

public constant sgp_irect = define_c_struct({
	C_INT, --x
	C_INT, --y
	C_INT, --w
	C_INT  --h
})

public constant sgp_rect = define_c_struct({
	C_FLOAT, --x
	C_FLOAT, --y
	C_FLOAT, --w
	C_FLOAT --h
})

public constant sgp_textured_rect = define_c_struct({
	sgp_rect, --dst
	sgp_rect --src
})

public constant sgp_vec2 = define_c_struct({
	C_FLOAT, --x
	C_FLOAT --y
})

public constant sgp_point = sgp_vec2 --typedef

public constant sgp_line = define_c_struct({
	sgp_point, --a
	sgp_point --b
})

public constant sgp_triangle = define_c_struct({
	sgp_point, --a
	sgp_point, --b
	sgp_point --c
})

public constant sgp_mat2x3 = define_c_struct({
	{C_FLOAT,2,3} --v[2][3]
})

public constant sgp_color = define_c_struct({
	C_FLOAT, --r
	C_FLOAT, --g
	C_FLOAT, --b
	C_FLOAT --a
})

public constant sgp_color_ub4 = define_c_struct({
	C_UINT8, --r
	C_UINT8, --g
	C_UINT8, --b
	C_UINT8 --a
})

public constant sgp_vertex = define_c_struct({
	sgp_vec2, --position
	sgp_vec2, --texcoord
	sgp_color_ub4 --color
})

public constant sgp_uniform_data = define_c_union({
	{C_FLOAT,SGP_UNIFORM_CONTENT_SLOTS}, --floats
	{C_UINT8, SGP_UNIFORM_CONTENT_SLOTS * sizeof(C_FLOAT)} --bytes
})

public constant sgp_uniform = define_c_struct({
	C_UINT16, --vs_size
	C_UINT16, --fs_size
	sgp_uniform_data --data
})

public constant sgp_textures_uniform = define_c_struct({
	C_UINT32, --count
	{sg_image,SGP_TEXTURE_SLOTS}, --images
	{sg_sampler,SGP_TEXTURE_SLOTS} --samplers
})

public constant sgp_state = define_c_struct({
	sgp_isize, --frame_size
	sgp_irect, --viewport
	sgp_irect, --scissor
	sgp_mat2x3, --proj
	sgp_mat2x3, --transform
	sgp_mat2x3, --mvp
	C_FLOAT, --thickness
	sgp_color_ub4, --color
	sgp_textures_uniform, --textures
	sgp_uniform, --uniform
	C_INT, --blend_mode
	sg_pipeline, --pipeline
	C_UINT32, --base_vertex
	C_UINT32, --base_uniform
	C_UINT32 --base_command
})

public constant sgp_desc = define_c_struct({
	C_UINT32, --max_vertices
	C_UINT32, --max_commands
	C_INT, --color_format
	C_INT, --depth_format
	C_INT --sample_count
})

public constant sgp_pipeline_desc = define_c_struct({
	sg_shader, --shader
	C_INT, --primitive_type
	C_INT, --blend_mode
	C_INT, --color_format
	C_INT, --depth_format
	C_INT, --sample_count
	C_BOOL --has_vs_color
})

public constant xsgp_setup = define_c_proc(gp,"+sgp_setup",{C_POINTER}),
				xsgp_shutdown = define_c_proc(gp,"+sgp_shutdown",{}),
				xsgp_is_valid = define_c_func(gp,"+sgp_is_valid",{},C_BOOL)
				
public procedure sgp_setup(atom desc)
	c_proc(xsgp_setup,{desc})
end procedure

public procedure sgp_shutdown()
	c_proc(xsgp_shutdown,{})
end procedure

public function sgp_is_valid()
	return c_func(xsgp_is_valid,{})
end function

public constant xsgp_get_last_error = define_c_func(gp,"+sgp_get_last_error",{},C_INT)

public function sgp_get_last_error()
	return c_func(xsgp_get_last_error,{})
end function

public constant xsgp_get_error_message = define_c_func(gp,"+sgp_get_error_message",{C_INT},C_STRING)

public function sgp_get_error_message(atom error)
	return c_func(xsgp_get_error_message,{error})
end function

public constant xsgp_make_pipeline = define_c_func(gp,"+sgp_make_pipeline",{C_POINTER},sg_pipeline)

public function sgp_make_pipeline(atom desc)
	return c_func(xsgp_make_pipeline,{desc})
end function

public constant xsgp_begin = define_c_proc(gp,"+sgp_begin",{C_INT,C_INT})

public procedure sgp_begin(atom width,atom height)
	c_proc(xsgp_begin,{width,height})
end procedure

public constant xsgp_flush = define_c_proc(gp,"+sgp_flush",{})

public procedure sgp_flush()
	c_proc(xsgp_flush,{})
end procedure

public constant xsgp_end = define_c_proc(gp,"+sgp_end",{})

public procedure sgp_end()
	c_proc(xsgp_end,{})
end procedure

public constant xsgp_project = define_c_proc(gp,"+sgp_project",{C_FLOAT,C_FLOAT,C_FLOAT,C_FLOAT})

public procedure sgp_project(atom left,atom right,atom top,atom bottom)
	c_proc(xsgp_project,{left,right,top,bottom})
end procedure

public constant xsgp_reset_project = define_c_proc(gp,"+sgp_reset_project",{})

public procedure sgp_reset_project()
	c_proc(xsgp_reset_project,{})
end procedure

public constant xsgp_push_transform = define_c_proc(gp,"+sgp_push_transform",{})

public procedure sgp_push_transform()
	c_proc(xsgp_push_transform,{})
end procedure

public constant xsgp_pop_transform = define_c_proc(gp,"+sgp_pop_transform",{})

public procedure sgp_pop_transform()
	c_proc(xsgp_pop_transform,{})
end procedure

public constant xsgp_reset_transform = define_c_proc(gp,"+sgp_reset_transform",{})

public procedure sgp_reset_transform()
	c_proc(xsgp_reset_transform,{})
end procedure

public constant xsgp_translate = define_c_proc(gp,"+sgp_translate",{C_FLOAT,C_FLOAT})

public procedure sgp_translate(atom x,atom y)
	c_proc(xsgp_translate,{x,y})
end procedure

public constant xsgp_rotate = define_c_proc(gp,"+sgp_rotate",{C_FLOAT})

public procedure sgp_rotate(atom theta)
	c_proc(xsgp_rotate,{theta})
end procedure

public constant xsgp_rotate_at = define_c_proc(gp,"+sgp_rotate_at",{C_FLOAT,C_FLOAT,C_FLOAT})

public procedure sgp_rotate_at(atom theta,atom x,atom y)
	c_proc(xsgp_rotate_at,{theta,x,y})
end procedure

public constant xsgp_scale = define_c_proc(gp,"+sgp_scale",{C_FLOAT,C_FLOAT})

public procedure sgp_scale(atom sx,atom sy)
	c_proc(xsgp_scale,{sx,sy})
end procedure

public constant xsgp_scale_at = define_c_proc(gp,"+sgp_scale_at",{C_FLOAT,C_FLOAT,C_FLOAT,C_FLOAT})

public procedure sgp_scale_at(atom sx,atom sy,atom x,atom y)
	c_proc(xsgp_scale_at,{sx,sy,x,y})
end procedure

public constant xsgp_set_pipeline = define_c_proc(gp,"+sgp_set_pipeline",{sg_pipeline})

public procedure sgp_set_pipeline(sequence pipeline)
	c_proc(xsgp_set_pipeline,{pipeline})
end procedure

public constant xsgp_reset_pipeline = define_c_proc(gp,"+sgp_reset_pipeline",{})

public procedure sgp_reset_pipeline()
	c_proc(xsgp_reset_pipeline,{})
end procedure

public constant xsgp_set_uniform = define_c_proc(gp,"+sgp_set_uniform",{C_POINTER,C_UINT32,C_POINTER,C_UINT32})

public procedure sgp_set_uniform(atom vs_data,atom vs_size,atom fs_data,atom fs_size)
	c_proc(xsgp_set_uniform,{vs_data,vs_size,fs_data,fs_size})
end procedure

public constant xsgp_reset_uniform = define_c_proc(gp,"+sgp_reset_uniform",{})

public procedure sgp_reset_uniform()
	c_proc(xsgp_reset_uniform,{})
end procedure

public constant xsgp_set_blend_mode = define_c_proc(gp,"+sgp_set_blend_mode",{C_INT})

public procedure sgp_set_blend_mode(atom blend_mode)
	c_proc(xsgp_set_blend_mode,{blend_mode})
end procedure

public constant xsgp_reset_blend_mode = define_c_proc(gp,"+sgp_reset_blend_mode",{})

public procedure sgp_reset_blend_mode()
	c_proc(xsgp_reset_blend_mode,{})
end procedure

public constant xsgp_set_color = define_c_proc(gp,"+sgp_set_color",{C_FLOAT,C_FLOAT,C_FLOAT,C_FLOAT})

public procedure sgp_set_color(atom r,atom g,atom b,atom a)
	c_proc(xsgp_set_color,{r,g,b,a})
end procedure

public constant xsgp_reset_color = define_c_proc(gp,"+sgp_reset_color",{})

public procedure sgp_reset_color()
	c_proc(xsgp_reset_color,{})
end procedure

public constant xsgp_set_image = define_c_proc(gp,"+sgp_set_image",{C_INT,sg_image})

public procedure sgp_set_image(atom channel,sequence image)
	c_proc(xsgp_set_image,{channel,image})
end procedure

public constant xsgp_unset_image = define_c_proc(gp,"+sgp_unset_image",{C_INT})

public procedure sgp_unset_image(atom channel)
	c_proc(xsgp_unset_image,{channel})
end procedure

public constant xsgp_reset_image = define_c_proc(gp,"+sgp_reset_image",{C_INT})

public procedure sgp_reset_image(atom channel)
	c_proc(xsgp_reset_image,{channel})
end procedure

public constant xsgp_set_sampler = define_c_proc(gp,"+sgp_set_sampler",{C_INT,sg_sampler})

public procedure sgp_set_sampler(atom channel,sequence sampler)
	c_proc(xsgp_set_sampler,{channel,sampler})
end procedure

public constant xsgp_reset_sampler = define_c_proc(gp,"+sgp_reset_sampler",{C_INT})

public procedure sgp_reset_sampler(atom channel)
	c_proc(xsgp_reset_sampler,{channel})
end procedure

public constant xsgp_viewport = define_c_proc(gp,"+sgp_viewport",{C_INT,C_INT,C_INT,C_INT})

public procedure sgp_viewport(atom x,atom y,atom w,atom h)
	c_proc(xsgp_viewport,{x,y,w,h})
end procedure

public constant xsgp_reset_viewport = define_c_proc(gp,"+sgp_reset_viewport",{})

public procedure sgp_reset_viewport()
	c_proc(xsgp_reset_viewport,{})
end procedure

public constant xsgp_scissor = define_c_proc(gp,"+sgp_scissor",{C_INT,C_INT,C_INT,C_INT})

public procedure sgp_scissor(atom x,atom y,atom w,atom h)
	c_proc(xsgp_scissor,{x,y,w,h})
end procedure

public constant xsgp_reset_scissor = define_c_proc(gp,"+sgp_reset_scissor",{})

public procedure sgp_reset_scissor()
	c_proc(xsgp_reset_scissor,{})
end procedure

public constant xsgp_reset_state = define_c_proc(gp,"+sgp_reset_state",{})

public procedure sgp_reset_state()
	c_proc(xsgp_reset_state,{})
end procedure

public constant xsgp_clear = define_c_proc(gp,"+sgp_clear",{})

public procedure sgp_clear()
	c_proc(xsgp_clear,{})
end procedure

public constant xsgp_draw = define_c_proc(gp,"+sgp_draw",{C_INT,C_POINTER,C_UINT32})

public procedure sgp_draw(atom primitive_type,atom vertices,atom count)
	c_proc(xsgp_draw,{primitive_type,vertices,count})
end procedure

public constant xsgp_draw_points = define_c_proc(gp,"+sgp_draw_points",{C_POINTER,C_UINT32})

public procedure sgp_draw_points(atom points,atom count)
	c_proc(xsgp_draw_points,{points,count})
end procedure

public constant xsgp_draw_point = define_c_proc(gp,"+sgp_draw_point",{C_FLOAT,C_FLOAT})

public procedure sgp_draw_point(atom x,atom y)
	c_proc(xsgp_draw_point,{x,y})
end procedure

public constant xsgp_draw_lines = define_c_proc(gp,"+sgp_draw_lines",{C_POINTER,C_UINT32})

public procedure sgp_draw_lines(atom lines,atom count)
	c_proc(xsgp_draw_lines,{lines,count})
end procedure

public constant xsgp_draw_line = define_c_proc(gp,"+sgp_draw_line",{C_FLOAT,C_FLOAT,C_FLOAT,C_FLOAT})

public procedure sgp_draw_line(atom ax,atom ay,atom bx,atom _by)
	c_proc(xsgp_draw_line,{ax,ay,bx,_by})
end procedure

public constant xsgp_draw_lines_strip = define_c_proc(gp,"+sgp_draw_lines_strip",{C_POINTER,C_UINT32})

public procedure sgp_draw_lines_strip(atom points,atom count)
	c_proc(xsgp_draw_lines_strip,{points,count})
end procedure

public constant xsgp_draw_filled_triangles = define_c_proc(gp,"+sgp_draw_filled_triangles",{C_POINTER,C_UINT32})

public procedure sgp_draw_filled_triangles(atom triangles,atom count)
	c_proc(xsgp_draw_filled_triangles,{triangles,count})
end procedure

public constant xsgp_draw_filled_triangle = define_c_proc(gp,"+sgp_draw_filled_triangle",{C_FLOAT,C_FLOAT,C_FLOAT,C_FLOAT,C_FLOAT,C_FLOAT})

public procedure sgp_draw_filled_triangle(atom ax,atom ay,atom bx,atom _by,atom cx,atom cy)
	c_proc(xsgp_draw_filled_triangle,{ax,ay,bx,_by,cx,cy})
end procedure

public constant xsgp_draw_filled_triangles_strip = define_c_proc(gp,"+sgp_draw_filled_triangles_strip",{C_POINTER,C_UINT32})

public procedure sgp_draw_filled_triangles_strip(atom points,atom count)
	c_proc(xsgp_draw_filled_triangles_strip,{points,count})
end procedure

public constant xsgp_draw_filled_rects = define_c_proc(gp,"+sgp_draw_filled_rects",{C_POINTER,C_UINT32})

public procedure sgp_draw_filled_rects(atom rects,atom count)
	c_proc(xsgp_draw_filled_rects,{rects,count})
end procedure

public constant xsgp_draw_filled_rect = define_c_proc(gp,"+sgp_draw_filled_rect",{C_FLOAT,C_FLOAT,C_FLOAT,C_FLOAT})

public procedure sgp_draw_filled_rect(atom x,atom y,atom w,atom h)
	c_proc(xsgp_draw_filled_rect,{x,y,w,h})
end procedure

public constant xsgp_draw_textured_rects = define_c_proc(gp,"+sgp_draw_textured_rects",{C_INT,C_POINTER,C_UINT32})

public procedure sgp_draw_textured_rects(atom channel,atom rects,atom count)
	c_proc(xsgp_draw_textured_rects,{channel,rects,count})
end procedure

public constant xsgp_draw_textured_rect = define_c_proc(gp,"+sgp_draw_textured_rect",{C_INT,sgp_rect,sgp_rect})

public procedure sgp_draw_textured_rect(atom channel,sequence dest_rect,sequence src_rect)
	c_proc(xsgp_draw_textured_rect,{channel,dest_rect,src_rect})
end procedure

public constant xsgp_query_state = define_c_func(gp,"+sgp_query_state",{},C_POINTER)

public function sgp_query_state()
	return c_func(xsgp_query_state,{})
end function

public constant xsgp_query_desc = define_c_func(gp,"+sgp_query_desc",{},sgp_desc)

public function sgp_query_desc()
	return c_func(xsgp_query_desc,{})
end function

public constant _SGP_IMPOSSIBLE_ID = 0xffffffff

public enum _SGP_INIT_COOKIE = 0xCAFED0D,
    _SGP_DEFAULT_MAX_VERTICES = 65536,
    _SGP_DEFAULT_MAX_COMMANDS = 16384,
    _SGP_MAX_MOVE_VERTICES = 96,
    _SGP_MAX_STACK_DEPTH = 64
    
public constant _sgp_region = define_c_struct({
	C_FLOAT, --x1
	C_FLOAT, --y1
	C_FLOAT, --x2
	C_FLOAT --y2
})

public constant _sgp_draw_args = define_c_struct({
	sg_pipeline, --pip
	sgp_textures_uniform, --textures
	_sgp_region, --region
	C_UINT32, --uniform_index
	C_UINT32, --vertex_index
	C_UINT32 --num_vertices
})

public constant _sgp_command_args = define_c_struct({
	_sgp_draw_args, --draw
	sgp_irect, --viewport
	sgp_irect --scissor
})

public enum type _sgp_command_type
	SGP_COMMAND_NONE = 0,
    SGP_COMMAND_DRAW,
    SGP_COMMAND_VIEWPORT,
    SGP_COMMAND_SCISSOR
end type

public constant _sgp_command = define_c_struct({
	C_INT, --cmd
	_sgp_command_args --args
})

public constant _sgp_context = define_c_struct({
	C_UINT32, --init_cookie
	C_INT, --error
	sgp_desc, --desc
	
	sg_shader, --shader
	sg_buffer, --vertex_buf
	sg_image, --white_img
	sg_sampler, --nearest_smp
	{sg_pipeline,_SG_PRIMITIVETYPE_NUM * _SGP_BLENDMODE_NUM},
	
	C_UINT32, --cur_vertex
	C_UINT32, --cur_uniform
	C_UINT32, --cur_command
	C_UINT32, --num_vertices
	C_UINT32, --num_uniforms
	C_UINT32, --num_commands
	C_POINTER, --vertices
	C_POINTER, --uniforms
	C_POINTER, --commands
	
	C_INT, --state
	
	C_UINT32, --cur_transform
	C_UINT32, --cur_state
	{sgp_mat2x3, _SGP_MAX_STACK_DEPTH}, --transform_stack
	{C_INT,_SGP_MAX_STACK_DEPTH} --state_stack
})
­590.43