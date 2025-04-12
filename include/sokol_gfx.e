--SokolGfx Wrapper
--Written by Andy P.
--OpenEuphoria wrapper for Sokol Gfx library
--Copyright (c) 2025

include std/ffi.e
include std/machine.e
include std/os.e

public atom gfx

ifdef WINDOWS then
	gfx = open_dll("sokol_gfx.dll")
	elsifdef LINUX or FREEBSD then
	gfx = open_dll("libsokol_gfx.so")
	elsifdef OSX then
	gfx = open_dll("libsokol_gfx.dylib")
end ifdef

if gfx = 0 then
	puts(1,"Failed to load sokol_gfx!\n")
	abort(0)
end if

public constant sg_buffer = C_UINT32
public constant sg_image = C_UINT32
public constant sg_sampler = C_UINT32
public constant sg_shader = C_UINT32
public constant sg_pipeline = C_UINT32
public constant sg_attachments = C_UINT32

public constant sg_range = define_c_struct({
	C_POINTER, --ptr
	C_SIZE_T --size
})

public enum SG_INVALID_ID = 0,
    SG_NUM_INFLIGHT_FRAMES = 2,
    SG_MAX_COLOR_ATTACHMENTS = 4,
    SG_MAX_UNIFORMBLOCK_MEMBERS = 16,
    SG_MAX_VERTEX_ATTRIBUTES = 16,
    SG_MAX_MIPMAPS = 16,
    SG_MAX_TEXTUREARRAY_LAYERS = 128,
    SG_MAX_UNIFORMBLOCK_BINDSLOTS = 8,
    SG_MAX_VERTEXBUFFER_BINDSLOTS = 8,
    SG_MAX_IMAGE_BINDSLOTS = 16,
    SG_MAX_SAMPLER_BINDSLOTS = 16,
    SG_MAX_STORAGEBUFFER_BINDSLOTS = 8,
    SG_MAX_IMAGE_SAMPLER_PAIRS = 16
    
public constant sg_color = define_c_struct({
	C_FLOAT, --r
	C_FLOAT, --g
	C_FLOAT, --b
	C_FLOAT  --a
})

public enum type sg_backend
	SG_BACKEND_GLCORE = 0,
    SG_BACKEND_GLES3,
    SG_BACKEND_D3D11,
    SG_BACKEND_METAL_IOS,
    SG_BACKEND_METAL_MACOS,
    SG_BACKEND_METAL_SIMULATOR,
    SG_BACKEND_WGPU,
    SG_BACKEND_DUMMY
end type

public enum type sg_pixel_format
	_SG_PIXELFORMAT_DEFAULT = 0,   -- // value 0 reserved for default-init
    SG_PIXELFORMAT_NONE,

    SG_PIXELFORMAT_R8,
    SG_PIXELFORMAT_R8SN,
    SG_PIXELFORMAT_R8UI,
    SG_PIXELFORMAT_R8SI,

    SG_PIXELFORMAT_R16,
    SG_PIXELFORMAT_R16SN,
    SG_PIXELFORMAT_R16UI,
    SG_PIXELFORMAT_R16SI,
    SG_PIXELFORMAT_R16F,
    SG_PIXELFORMAT_RG8,
    SG_PIXELFORMAT_RG8SN,
    SG_PIXELFORMAT_RG8UI,
    SG_PIXELFORMAT_RG8SI,

    SG_PIXELFORMAT_R32UI,
    SG_PIXELFORMAT_R32SI,
    SG_PIXELFORMAT_R32F,
    SG_PIXELFORMAT_RG16,
    SG_PIXELFORMAT_RG16SN,
    SG_PIXELFORMAT_RG16UI,
    SG_PIXELFORMAT_RG16SI,
    SG_PIXELFORMAT_RG16F,
    SG_PIXELFORMAT_RGBA8,
    SG_PIXELFORMAT_SRGB8A8,
    SG_PIXELFORMAT_RGBA8SN,
    SG_PIXELFORMAT_RGBA8UI,
    SG_PIXELFORMAT_RGBA8SI,
    SG_PIXELFORMAT_BGRA8,
    SG_PIXELFORMAT_RGB10A2,
    SG_PIXELFORMAT_RG11B10F,
    SG_PIXELFORMAT_RGB9E5,

    SG_PIXELFORMAT_RG32UI,
    SG_PIXELFORMAT_RG32SI,
    SG_PIXELFORMAT_RG32F,
    SG_PIXELFORMAT_RGBA16,
    SG_PIXELFORMAT_RGBA16SN,
    SG_PIXELFORMAT_RGBA16UI,
    SG_PIXELFORMAT_RGBA16SI,
    SG_PIXELFORMAT_RGBA16F,

    SG_PIXELFORMAT_RGBA32UI,
    SG_PIXELFORMAT_RGBA32SI,
    SG_PIXELFORMAT_RGBA32F,

    --// NOTE: when adding/removing pixel formats before DEPTH, also update sokol_app.h/_SAPP_PIXELFORMAT_*
    SG_PIXELFORMAT_DEPTH,
    SG_PIXELFORMAT_DEPTH_STENCIL,

    --// NOTE: don't put any new compressed format in front of here
    SG_PIXELFORMAT_BC1_RGBA,
    SG_PIXELFORMAT_BC2_RGBA,
    SG_PIXELFORMAT_BC3_RGBA,
    SG_PIXELFORMAT_BC3_SRGBA,
    SG_PIXELFORMAT_BC4_R,
    SG_PIXELFORMAT_BC4_RSN,
    SG_PIXELFORMAT_BC5_RG,
    SG_PIXELFORMAT_BC5_RGSN,
    SG_PIXELFORMAT_BC6H_RGBF,
    SG_PIXELFORMAT_BC6H_RGBUF,
    SG_PIXELFORMAT_BC7_RGBA,
    SG_PIXELFORMAT_BC7_SRGBA,
    SG_PIXELFORMAT_ETC2_RGB8,
    SG_PIXELFORMAT_ETC2_SRGB8,
    SG_PIXELFORMAT_ETC2_RGB8A1,
    SG_PIXELFORMAT_ETC2_RGBA8,
    SG_PIXELFORMAT_ETC2_SRGB8A8,
    SG_PIXELFORMAT_EAC_R11,
    SG_PIXELFORMAT_EAC_R11SN,
    SG_PIXELFORMAT_EAC_RG11,
    SG_PIXELFORMAT_EAC_RG11SN,

    SG_PIXELFORMAT_ASTC_4x4_RGBA,
    SG_PIXELFORMAT_ASTC_4x4_SRGBA,

    _SG_PIXELFORMAT_NUM,
    _SG_PIXELFORMAT_FORCE_U32 = 0x7FFFFFFF
end type

public constant sg_pixelformat_info = define_c_struct({
	C_BOOL, --sample
	C_BOOL, --filter
	C_BOOL, --render
	C_BOOL, --blend
	C_BOOL, --msaa
	C_BOOL, --depth
	C_BOOL, --compressed
	C_INT  --bytes_per_pixel
})

public constant sg_features = define_c_struct({
	C_BOOL, --origin_top_left
	C_BOOL, --image_clamp_to_border
	C_BOOL, --mrt_independent_blend_state
	C_BOOL, --mrt_independent_write_mask
	C_BOOL, --compute
	C_BOOL  --msaa_image_bindings
})

public constant sg_limits = define_c_struct({
	C_INT, --max_image_size_2d
	C_INT, --max_image_size_cube
	C_INT, --max_image_size_3d
	C_INT, --max_image_size_array
	C_INT, --max_image_array_layers
	C_INT, --max_vertex_attrs
	C_INT, --gl_max_vertex_uniform_components
	C_INT  --gl_max_combined_texture_image_units
})

public enum type sg_resource_state
	 SG_RESOURCESTATE_INITIAL = 0,
    SG_RESOURCESTATE_ALLOC,
    SG_RESOURCESTATE_VALID,
    SG_RESOURCESTATE_FAILED,
    SG_RESOURCESTATE_INVALID,
    _SG_RESOURCESTATE_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_usage
	_SG_USAGE_DEFAULT = 0,    --  // value 0 reserved for default-init
    SG_USAGE_IMMUTABLE,
    SG_USAGE_DYNAMIC,
    SG_USAGE_STREAM,
    _SG_USAGE_NUM,
    _SG_USAGE_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_buffer_type
	 _SG_BUFFERTYPE_DEFAULT = 0,     --    // value 0 reserved for default-init
    SG_BUFFERTYPE_VERTEXBUFFER,
    SG_BUFFERTYPE_INDEXBUFFER,
    SG_BUFFERTYPE_STORAGEBUFFER,
    _SG_BUFFERTYPE_NUM,
    _SG_BUFFERTYPE_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_index_type
	  _SG_INDEXTYPE_DEFAULT = 0,  -- // value 0 reserved for default-init
    SG_INDEXTYPE_NONE,
    SG_INDEXTYPE_UINT16,
    SG_INDEXTYPE_UINT32,
    _SG_INDEXTYPE_NUM,
    _SG_INDEXTYPE_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_image_type
	 _SG_IMAGETYPE_DEFAULT = 0, -- // value 0 reserved for default-init
    SG_IMAGETYPE_2D,
    SG_IMAGETYPE_CUBE,
    SG_IMAGETYPE_3D,
    SG_IMAGETYPE_ARRAY,
    _SG_IMAGETYPE_NUM,
    _SG_IMAGETYPE_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_image_sample_type
	 _SG_IMAGESAMPLETYPE_DEFAULT = 0, -- // value 0 reserved for default-init
    SG_IMAGESAMPLETYPE_FLOAT,
    SG_IMAGESAMPLETYPE_DEPTH,
    SG_IMAGESAMPLETYPE_SINT,
    SG_IMAGESAMPLETYPE_UINT,
    SG_IMAGESAMPLETYPE_UNFILTERABLE_FLOAT,
    _SG_IMAGESAMPLETYPE_NUM,
    _SG_IMAGESAMPLETYPE_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_sampler_type
	_SG_SAMPLERTYPE_DEFAULT = 0,
    SG_SAMPLERTYPE_FILTERING,
    SG_SAMPLERTYPE_NONFILTERING,
    SG_SAMPLERTYPE_COMPARISON,
    _SG_SAMPLERTYPE_NUM,
    _SG_SAMPLERTYPE_FORCE_U32
end type

public enum type sg_cube_face
	SG_CUBEFACE_POS_X = 0,
    SG_CUBEFACE_NEG_X,
    SG_CUBEFACE_POS_Y,
    SG_CUBEFACE_NEG_Y,
    SG_CUBEFACE_POS_Z,
    SG_CUBEFACE_NEG_Z,
    SG_CUBEFACE_NUM,
    _SG_CUBEFACE_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_primitive_type
	 _SG_PRIMITIVETYPE_DEFAULT = 0, -- // value 0 reserved for default-init
    SG_PRIMITIVETYPE_POINTS,
    SG_PRIMITIVETYPE_LINES,
    SG_PRIMITIVETYPE_LINE_STRIP,
    SG_PRIMITIVETYPE_TRIANGLES,
    SG_PRIMITIVETYPE_TRIANGLE_STRIP,
    _SG_PRIMITIVETYPE_NUM,
    _SG_PRIMITIVETYPE_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_filter
	_SG_FILTER_DEFAULT = 0, --// value 0 reserved for default-init
    SG_FILTER_NEAREST,
    SG_FILTER_LINEAR,
    _SG_FILTER_NUM,
    _SG_FILTER_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_wrap
	 _SG_WRAP_DEFAULT = 0, --  // value 0 reserved for default-init
    SG_WRAP_REPEAT,
    SG_WRAP_CLAMP_TO_EDGE,
    SG_WRAP_CLAMP_TO_BORDER,
    SG_WRAP_MIRRORED_REPEAT,
    _SG_WRAP_NUM,
    _SG_WRAP_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_border_color
	_SG_BORDERCOLOR_DEFAULT = 0, --   // value 0 reserved for default-init
    SG_BORDERCOLOR_TRANSPARENT_BLACK,
    SG_BORDERCOLOR_OPAQUE_BLACK,
    SG_BORDERCOLOR_OPAQUE_WHITE,
    _SG_BORDERCOLOR_NUM,
    _SG_BORDERCOLOR_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_vertex_format
	 SG_VERTEXFORMAT_INVALID = 0,
    SG_VERTEXFORMAT_FLOAT,
    SG_VERTEXFORMAT_FLOAT2,
    SG_VERTEXFORMAT_FLOAT3,
    SG_VERTEXFORMAT_FLOAT4,
    SG_VERTEXFORMAT_INT,
    SG_VERTEXFORMAT_INT2,
    SG_VERTEXFORMAT_INT3,
    SG_VERTEXFORMAT_INT4,
    SG_VERTEXFORMAT_UINT,
    SG_VERTEXFORMAT_UINT2,
    SG_VERTEXFORMAT_UINT3,
    SG_VERTEXFORMAT_UINT4,
    SG_VERTEXFORMAT_BYTE4,
    SG_VERTEXFORMAT_BYTE4N,
    SG_VERTEXFORMAT_UBYTE4,
    SG_VERTEXFORMAT_UBYTE4N,
    SG_VERTEXFORMAT_SHORT2,
    SG_VERTEXFORMAT_SHORT2N,
    SG_VERTEXFORMAT_USHORT2,
    SG_VERTEXFORMAT_USHORT2N,
    SG_VERTEXFORMAT_SHORT4,
    SG_VERTEXFORMAT_SHORT4N,
    SG_VERTEXFORMAT_USHORT4,
    SG_VERTEXFORMAT_USHORT4N,
    SG_VERTEXFORMAT_UINT10_N2,
    SG_VERTEXFORMAT_HALF2,
    SG_VERTEXFORMAT_HALF4,
    _SG_VERTEXFORMAT_NUM,
    _SG_VERTEXFORMAT_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_vertex_step
	_SG_VERTEXSTEP_DEFAULT = 0,  --   // value 0 reserved for default-init
    SG_VERTEXSTEP_PER_VERTEX,
    SG_VERTEXSTEP_PER_INSTANCE,
    _SG_VERTEXSTEP_NUM,
    _SG_VERTEXSTEP_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_uniform_type
	SG_UNIFORMTYPE_INVALID = 0,
    SG_UNIFORMTYPE_FLOAT,
    SG_UNIFORMTYPE_FLOAT2,
    SG_UNIFORMTYPE_FLOAT3,
    SG_UNIFORMTYPE_FLOAT4,
    SG_UNIFORMTYPE_INT,
    SG_UNIFORMTYPE_INT2,
    SG_UNIFORMTYPE_INT3,
    SG_UNIFORMTYPE_INT4,
    SG_UNIFORMTYPE_MAT4,
    _SG_UNIFORMTYPE_NUM,
    _SG_UNIFORMTYPE_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_uniform_layout
	 _SG_UNIFORMLAYOUT_DEFAULT = 0, --    // value 0 reserved for default-init
    SG_UNIFORMLAYOUT_NATIVE,      -- // default: layout depends on currently active backend
    SG_UNIFORMLAYOUT_STD140,      -- // std140: memory layout according to std140
    _SG_UNIFORMLAYOUT_NUM,
    _SG_UNIFORMLAYOUT_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_cull_mode
	 _SG_CULLMODE_DEFAULT = 0, --  // value 0 reserved for default-init
    SG_CULLMODE_NONE,
    SG_CULLMODE_FRONT,
    SG_CULLMODE_BACK,
    _SG_CULLMODE_NUM,
    _SG_CULLMODE_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_face_winding
	  _SG_FACEWINDING_DEFAULT = 0,  --  // value 0 reserved for default-init
    SG_FACEWINDING_CCW,
    SG_FACEWINDING_CW,
    _SG_FACEWINDING_NUM,
    _SG_FACEWINDING_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_compare_func
	 _SG_COMPAREFUNC_DEFAULT = 0, --   // value 0 reserved for default-init
    SG_COMPAREFUNC_NEVER,
    SG_COMPAREFUNC_LESS,
    SG_COMPAREFUNC_EQUAL,
    SG_COMPAREFUNC_LESS_EQUAL,
    SG_COMPAREFUNC_GREATER,
    SG_COMPAREFUNC_NOT_EQUAL,
    SG_COMPAREFUNC_GREATER_EQUAL,
    SG_COMPAREFUNC_ALWAYS,
    _SG_COMPAREFUNC_NUM,
    _SG_COMPAREFUNC_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_stencil_op
	 _SG_STENCILOP_DEFAULT = 0, --     // value 0 reserved for default-init
    SG_STENCILOP_KEEP,
    SG_STENCILOP_ZERO,
    SG_STENCILOP_REPLACE,
    SG_STENCILOP_INCR_CLAMP,
    SG_STENCILOP_DECR_CLAMP,
    SG_STENCILOP_INVERT,
    SG_STENCILOP_INCR_WRAP,
    SG_STENCILOP_DECR_WRAP,
    _SG_STENCILOP_NUM,
    _SG_STENCILOP_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_blend_factor
	_SG_BLENDFACTOR_DEFAULT = 0, --   // value 0 reserved for default-init
    SG_BLENDFACTOR_ZERO,
    SG_BLENDFACTOR_ONE,
    SG_BLENDFACTOR_SRC_COLOR,
    SG_BLENDFACTOR_ONE_MINUS_SRC_COLOR,
    SG_BLENDFACTOR_SRC_ALPHA,
    SG_BLENDFACTOR_ONE_MINUS_SRC_ALPHA,
    SG_BLENDFACTOR_DST_COLOR,
    SG_BLENDFACTOR_ONE_MINUS_DST_COLOR,
    SG_BLENDFACTOR_DST_ALPHA,
    SG_BLENDFACTOR_ONE_MINUS_DST_ALPHA,
    SG_BLENDFACTOR_SRC_ALPHA_SATURATED,
    SG_BLENDFACTOR_BLEND_COLOR,
    SG_BLENDFACTOR_ONE_MINUS_BLEND_COLOR,
    SG_BLENDFACTOR_BLEND_ALPHA,
    SG_BLENDFACTOR_ONE_MINUS_BLEND_ALPHA,
    _SG_BLENDFACTOR_NUM,
    _SG_BLENDFACTOR_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_blend_op
	_SG_BLENDOP_DEFAULT = 0, --   // value 0 reserved for default-init
    SG_BLENDOP_ADD,
    SG_BLENDOP_SUBTRACT,
    SG_BLENDOP_REVERSE_SUBTRACT,
    SG_BLENDOP_MIN,
    SG_BLENDOP_MAX,
    _SG_BLENDOP_NUM,
    _SG_BLENDOP_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_color_mask
	  _SG_COLORMASK_DEFAULT = 0, --   // value 0 reserved for default-init
    SG_COLORMASK_NONE   = 0x10,  -- // special value for 'all channels disabled
    SG_COLORMASK_R      = 0x1,
    SG_COLORMASK_G      = 0x2,
    SG_COLORMASK_RG     = 0x3,
    SG_COLORMASK_B      = 0x4,
    SG_COLORMASK_RB     = 0x5,
    SG_COLORMASK_GB     = 0x6,
    SG_COLORMASK_RGB    = 0x7,
    SG_COLORMASK_A      = 0x8,
    SG_COLORMASK_RA     = 0x9,
    SG_COLORMASK_GA     = 0xA,
    SG_COLORMASK_RGA    = 0xB,
    SG_COLORMASK_BA     = 0xC,
    SG_COLORMASK_RBA    = 0xD,
    SG_COLORMASK_GBA    = 0xE,
    SG_COLORMASK_RGBA   = 0xF,
    _SG_COLORMASK_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_load_action
	_SG_LOADACTION_DEFAULT = 0,
    SG_LOADACTION_CLEAR,
    SG_LOADACTION_LOAD,
    SG_LOADACTION_DONTCARE,
    _SG_LOADACTION_FORCE_U32 = 0x7FFFFFFF
end type

public enum type sg_store_action
	_SG_STOREACTION_DEFAULT = 0,
    SG_STOREACTION_STORE,
    SG_STOREACTION_DONTCARE,
    _SG_STOREACTION_FORCE_U32 = 0x7FFFFFFF
end type

public constant sg_color_attachment_action = define_c_struct({
	C_INT, --load_action
	C_INT, --store_action
	C_INT --clear_value
})

public constant sg_depth_attachment_action = define_c_struct({
	C_INT, --load_action
	C_INT, --store_action
	C_FLOAT --clear_value
})

public constant sg_stencil_attachment_action = define_c_struct({
	C_INT, --load_action
	C_INT, --store_action
	C_UINT8 --clear_value
})

public constant sg_pass_action = define_c_struct({
	{sg_color_attachment_action,SG_MAX_COLOR_ATTACHMENTS}, --colors
	sg_depth_attachment_action, --depth
	sg_stencil_attachment_action --stencil
})

public constant sg_metal_swapchain = define_c_struct({
	C_POINTER, --current_drawable
	C_POINTER, --depth_stencil_texture
	C_POINTER --msaa_color_texture
})

public constant sg_d3d11_swapchain = define_c_struct({
	C_POINTER, --render_view
	C_POINTER, --resolve_view
	C_POINTER --depth_stencil_view
})

public constant sg_wgpu_swapchain = define_c_struct({
	C_POINTER, --render_view
	C_POINTER, --resolve_view
	C_POINTER --depth_stencil_view
})

public constant sg_gl_swapchain = define_c_struct({
	C_UINT32 --framebuffer
})

public constant sg_swapchain = define_c_struct({
	C_INT, --width
	C_INT, --height
	C_INT, --sample_count
	C_INT, --color_format
	C_INT, --depth_format
	sg_metal_swapchain, --metal
	sg_d3d11_swapchain, --d3d11
	sg_wgpu_swapchain, --wgpu
	sg_gl_swapchain --gl
})

public constant sg_pass = define_c_struct({
	C_UINT32, --start_canary
	C_BOOL, --compute
	sg_pass_action, --action
	sg_attachments, --attachments
	sg_swapchain, --swapchain
	C_STRING, --label
	C_UINT32 --end_canary
})

public constant sg_bindings = define_c_struct({
	C_UINT32, --start_canary
	{sg_buffer,SG_MAX_VERTEXBUFFER_BINDSLOTS}, --vertex_buffers
	{C_INT,SG_MAX_VERTEXBUFFER_BINDSLOTS}, --vertex_buffer_offsets
	sg_buffer, --index_buffer
	C_INT, --index_buffer_offset
	{sg_image,SG_MAX_IMAGE_BINDSLOTS}, --images
	{sg_sampler,SG_MAX_SAMPLER_BINDSLOTS}, --samplers
	{sg_buffer,SG_MAX_STORAGEBUFFER_BINDSLOTS} --storage_buffers
})

public constant sg_buffer_desc = define_c_struct({
	C_UINT32, --start_canary
	C_SIZE_T, --size
	C_INT, --sg buffer_type
	C_INT, --sg usage
	sg_range, --data
	C_STRING, --label
	{C_UINT32,SG_NUM_INFLIGHT_FRAMES}, --gl_buffers
	{C_POINTER,SG_NUM_INFLIGHT_FRAMES}, --mtl_buffers
	C_POINTER, --d3d11_buffer
	C_POINTER, --wgpu_buffer
	C_UINT32 --end_canary
})

public constant sg_image_data = define_c_struct({
 {sg_range,SG_CUBEFACE_NUM,SG_MAX_MIPMAPS} --subimage
})

public constant sg_image_desc = define_c_struct({
	C_UINT32, --start_canary
	C_INT, --sg image type
	C_BOOL, --render_target
	C_INT, --width
	C_INT, --height
	C_INT, -- num_slices
	C_INT, --num_mipmaps
	C_INT, --sg usage
	C_INT, --pixel_format
	C_INT, --sample_count
	sg_image_data, --image data
	C_STRING, --label
	{C_UINT32,SG_NUM_INFLIGHT_FRAMES}, --gl_textures
	C_UINT32, --gl_texture_target
	{C_POINTER,SG_NUM_INFLIGHT_FRAMES}, --mtl_textures
	C_POINTER, --d3d11_texture
	C_POINTER, --d3d11_shader_resource_view
	C_POINTER, --wgpu_texture
	C_POINTER, --wgpu_texture_view
	C_UINT32 --end_canary
})

public constant sg_sampler_desc = define_c_struct({
	C_UINT32, --start_canary
	C_INT, --sg min_filter
	C_INT, --sg mag_filter
	C_INT, --sg mipmap_filter
	C_INT, --wrap_u
	C_INT, --wrap_v
	C_INT, --wrap_w
	C_FLOAT, --min_lod
	C_FLOAT, --max_lod
	C_INT, --border_color
	C_INT, --compare
	C_UINT32, --max_anisotropy
	C_STRING, --label
	C_UINT32, --gl_sampler
	C_POINTER, --mtl_sampler
	C_POINTER, --d3d11_sampler
	C_POINTER, --wgpu_sampler
	C_UINT32 --end_canary
})

public enum type sg_shader_stage
	 SG_SHADERSTAGE_NONE = 0,
    SG_SHADERSTAGE_VERTEX,
    SG_SHADERSTAGE_FRAGMENT,
    SG_SHADERSTAGE_COMPUTE,
    _SG_SHADERSTAGE_FORCE_U32 = 0x7FFFFFFF
end type

public constant sg_shader_function = define_c_struct({
	C_STRING, --source
	sg_range, --bytecode
	C_STRING, --entry
	C_STRING --d3d11_target
})

public enum type sg_shader_attr_base_type
	SG_SHADERATTRBASETYPE_UNDEFINED = 0,
    SG_SHADERATTRBASETYPE_FLOAT,
    SG_SHADERATTRBASETYPE_SINT,
    SG_SHADERATTRBASETYPE_UINT,
    _SG_SHADERATTRBASETYPE_FORCE_U32 = 0x7FFFFFFF
end type

public constant sg_shader_vertex_attr = define_c_struct({
	C_INT, --base_type
	C_STRING, --glsl_name
	C_STRING, --hlsl_sem_name
	C_UINT8 --hlsl_sem_index
})

public constant sg_glsl_shader_uniform = define_c_struct({
	C_INT, --uniform type
	C_UINT16, --array_count
	C_STRING --glsl_name
})

public constant sg_shader_uniform_block = define_c_struct({
	C_INT, --sg shader stage
	C_UINT32, --size
	C_UINT8, --hlsl_register_b_n
	C_UINT8, --msl_buffer_n
	C_UINT8, --wgsl_group0_binding_n
	C_INT, --sg_uniform_layout
	{sg_glsl_shader_uniform,SG_MAX_UNIFORMBLOCK_MEMBERS} --sg_glsl_shader_uniform
})

public constant sg_shader_image = define_c_struct({
	C_INT, --sg shader stage
	C_INT, --image_type
	C_INT, --sg sample type
	C_BOOL, --multisampled
	C_UINT8, --hlsl_register_t_n
	C_UINT8, --msl_texture_n
	C_UINT8 --wgsl_group1_binding_n
})

public constant sg_shader_sampler = define_c_struct({
	C_INT, --stage sg shader stage
	C_INT, --sampler type
	C_UINT8, --hlsl_register_s_n
	C_UINT8, --msl_sampler_n
	C_UINT8 --wgsl_group1_binding_n
})

public constant sg_shader_storage_buffer = define_c_struct({
	C_INT, --stage sg shader
	C_BOOL, --readonly
	C_UINT8, --hlsl_register_t_n
	C_UINT8, --hlsl_register_u_n
	C_UINT8, --msl_buffer_n
	C_UINT8, --wgsl_group1_binding_n
	C_UINT8 --glsl_binding_n
})

public constant sg_shader_image_sampler_pair = define_c_struct({
	C_INT, --sg shader stage
	C_UINT8, --image_slot
	C_UINT8, --sampler_slot
	C_STRING --glsl_name
})

public constant sg_mtl_shader_threads_per_threadgroup = define_c_struct({
	C_INT, --x
	C_INT, --y
	C_INT  --z
})

public constant sg_shader_desc = define_c_struct({
	C_UINT32, --start_canary
	sg_shader_function, --vertex_func
	sg_shader_function, --fragment_func
	sg_shader_function, --compute_func
	{sg_shader_vertex_attr,SG_MAX_VERTEX_ATTRIBUTES}, --attrs
	{sg_shader_uniform_block,SG_MAX_UNIFORMBLOCK_BINDSLOTS}, --uniform_blocks
	{sg_shader_storage_buffer,SG_MAX_STORAGEBUFFER_BINDSLOTS}, --storage_buffers
	{sg_shader_image,SG_MAX_IMAGE_BINDSLOTS}, --images
	{sg_shader_sampler,SG_MAX_SAMPLER_BINDSLOTS}, --samplers
	{sg_shader_image_sampler_pair,SG_MAX_IMAGE_SAMPLER_PAIRS}, --image_sampler_pairs
	sg_mtl_shader_threads_per_threadgroup, --mtl_threads_per_threadgroup
	C_STRING, --label
	C_UINT32 --end_canary
})

public constant sg_vertex_buffer_layout_state = define_c_struct({
	C_INT, --stride
	C_INT, --ssg_vertex_step tep_func
	C_INT --step_rate
})

public constant sg_vertex_attr_state = define_c_struct({
	C_INT, --buffer_index
	C_INT, --offset
	C_INT --sg_vertex_format format
})

public constant sg_vertex_layout_state = define_c_struct({
	{sg_vertex_buffer_layout_state,SG_MAX_VERTEXBUFFER_BINDSLOTS}, --buffers
	{sg_vertex_attr_state,SG_MAX_VERTEX_ATTRIBUTES} --attrs
})

public constant sg_stencil_face_state = define_c_struct({
	C_INT, --compare
	C_INT, --fail_op
	C_INT, --depth_fail_op
	C_INT --pass_op
})

public constant sg_stencil_state = define_c_struct({
	C_BOOL, --enabled
	sg_stencil_face_state, --front
	sg_stencil_face_state, --back
	C_UINT8, --read_mask
	C_UINT8, --write_mask
	C_UINT8 --ref
})

public constant sg_depth_state = define_c_struct({
	C_INT, --pixel_format sg_pixel_format
	C_INT, --compare sg_compare_func
	C_BOOL, --write_enabled
	C_FLOAT, --bias
	C_FLOAT, --bias_slope_scale
	C_FLOAT --bias_clamp
})

public constant sg_blend_state = define_c_struct({
	C_BOOL, --enabled
	C_INT, --src_factor_rgb
	C_INT, --dst_factor_rgb
	C_INT, --op_rgb
	C_INT, --src_factor_alpha
	C_INT, --dst_factor_alpha
	C_INT --op_alpha
})

public constant sg_color_target_state = define_c_struct({
	C_INT, --pixel_format
	C_INT, --write_mask sg_color_mask
	C_INT --blend
})

public constant sg_pipeline_desc = define_c_struct({
	C_UINT32, --start_canary
	C_BOOL, --compute
	sg_shader, --shader
	sg_vertex_layout_state, --layout
	sg_depth_state, --depth
	sg_stencil_state, --stencil
	C_INT, --color_count
	{sg_color_target_state,SG_MAX_COLOR_ATTACHMENTS}, --colors
	C_INT, --primitive_type
	C_INT, --index_type
	C_INT, --cull_mode
	C_INT, --face_winding
	C_INT, --sample_count
	sg_color, --blend_color
	C_BOOL, --alpha_to_coverage_enabled
	C_STRING, --label
	C_UINT32 --end_canary
})

public constant sg_attachment_desc = define_c_struct({
	sg_image, --image
	C_INT, --mip_level
	C_INT --slice
})

public constant sg_attachments_desc = define_c_struct({
	C_UINT32, --start_canary
	{sg_attachment_desc,SG_MAX_COLOR_ATTACHMENTS}, --color
	{sg_attachment_desc,SG_MAX_COLOR_ATTACHMENTS}, --resolves
	sg_attachment_desc, --depth_stencil
	C_STRING, --label
	C_UINT32 --end_canary
})

--not wrapped sg_trace_hooks struct

public constant sg_slot_info = define_c_struct({
	C_INT, --state sg_resource_state
	C_UINT32 --res_id
})

public constant sg_buffer_info = define_c_struct({
	sg_slot_info, --slot
	C_UINT32, --update_frame_index
	C_UINT32, --append_frame_index
	C_INT, --append_pos
	C_BOOL, --append_overflow
	C_INT, --num_slots
	C_INT --active_slot
})

public constant sg_image_info = define_c_struct({
	sg_slot_info, --slot
	C_UINT32, --upd_frame_index
	C_INT, --num_slots
	C_INT --active_slot
})

public constant sg_sampler_info = define_c_struct({
	sg_slot_info --slot
})

public constant sg_shader_info = define_c_struct({
	sg_slot_info --slot
})

public constant sg_pipeline_info = define_c_struct({
	sg_slot_info --slot
})

public constant sg_attachments_info = define_c_struct({
	sg_slot_info --slot
})

public constant sg_frame_stats_gl = define_c_struct({
	C_UINT32, --num_bind_buffer
	C_UINT32, --num_active_texture
	C_UINT32, --num_bind_texture
	C_UINT32, --num_bind_sampler
	C_UINT32, --num_use_program
	C_UINT32, --num_render_state
	C_UINT32, --num_vertex_attrib_pointer
	C_UINT32, --num_vertex_attrib_divisor
	C_UINT32, --num_enable_vertex_attrib_array
	C_UINT32, --num_disable_vertex_attrib_array
	C_UINT32, --num_uniform
	C_UINT32 --num_memory_barriers
})

public constant sg_frame_stats_d3d11_pass = define_c_struct({
	C_UINT32, --num_om_set_render_targets
	C_UINT32, --num_clear_render_target_view
	C_UINT32, --num_clear_depth_stencil_view
	C_UINT32 --num_resolve_subresource
})

public constant sg_frame_stats_d3d11_pipeline = define_c_struct({
	C_UINT32, --num_rs_set_state
	C_UINT32, --num_om_set_depth_stencil_state
	C_UINT32, --num_om_set_blend_state
	C_UINT32, --num_ia_set_primitive_topology
	C_UINT32, --num_ia_set_input_layout
	C_UINT32, --num_vs_set_shader
	C_UINT32, --num_vs_set_constant_buffers
	C_UINT32, --num_ps_set_shader
	C_UINT32, --num_ps_set_constant_buffers
	C_UINT32, --num_cs_set_shader
	C_UINT32 --num_cs_set_constant_buffers
})

public constant sg_frame_stats_d3d11_bindings = define_c_struct({
	C_UINT32, --num_ia_set_vertex_buffers
	C_UINT32, --num_ia_set_index_buffer
	C_UINT32, --num_vs_set_shader_resources
	C_UINT32, --num_vs_set_samplers
	C_UINT32, --num_ps_set_shader_resources
	C_UINT32, --num_ps_set_samplers
	C_UINT32, --num_cs_set_shader_resources
	C_UINT32, --num_cs_set_samplers
	C_UINT32 --num_cs_set_unordered_access_views
})

public constant sg_frame_stats_d3d11_uniforms = define_c_struct({
	C_UINT32 --num_update_subresource
})

public constant sg_frame_stats_d3d11_draw = define_c_struct({
	C_UINT32, --num_draw_index_instanced
	C_UINT32, --num_draw_indexed
	C_UINT32, --num_draw_instanced
	C_UINT32 --num_draw
})

public constant sg_frame_stats_d3d11 = define_c_struct({
	sg_frame_stats_d3d11_pass, --pass
	sg_frame_stats_d3d11_pipeline, --pipeline
	sg_frame_stats_d3d11_bindings, --bindings
	sg_frame_stats_d3d11_uniforms, --uniforms
	sg_frame_stats_d3d11_draw, --draw
	C_UINT32, --num_map
	C_UINT32 --num_unmap
})

public constant sg_frame_stats_metal_idpool = define_c_struct({
	C_UINT32, --num_added
	C_UINT32, --num_released
	C_UINT32 --num_garbage_collected
})

public constant sg_frame_stats_metal_pipeline = define_c_struct({
	C_UINT32, --num_set_blend_color
	C_UINT32, --num_set_cull_mode
	C_UINT32, --num_set_front_facing_winding
	C_UINT32, --num_set_stencil_reference_value
	C_UINT32, --num_set_depth_bias
	C_UINT32, --num_set_render_pipeline_state
	C_UINT32 --num_set_depth_stencil_state
})

public constant sg_frame_stats_metal_bindings = define_c_struct({
	C_UINT32, --num_set_vertex_buffer
	C_UINT32, --num_set_vertex_texture
	C_UINT32, --num_set_vertex_sampler_state
	C_UINT32, --num_set_fragment_buffer
	C_UINT32, --num_set_fragment_texture
	C_UINT32, --num_set_fragment_sampler_state
	C_UINT32, --num_set_compute_buffer
	C_UINT32, --num_set_compute_texture
	C_UINT32 --num_set_compute_sampler_state
})

public constant sg_frame_stats_metal_uniforms = define_c_struct({
	C_UINT32, --num_set_vertex_buffer_offset
	C_UINT32, --num_set_fragment_buffer_offset
	C_UINT32 --num_set_compute_buffer_offset
})

public constant sg_frame_stats_metal = define_c_struct({
	sg_frame_stats_metal_idpool, --idpool
	sg_frame_stats_metal_pipeline, --pipeline
	sg_frame_stats_metal_bindings, --bindings
	sg_frame_stats_metal_uniforms --uniforms
})

public constant sg_frame_stats_wgpu_uniforms = define_c_struct({
	C_UINT32, --num_set_bindgroup
	C_UINT32 --size_write_buffer
})

public constant sg_frame_stats_wgpu_bindings = define_c_struct({
	C_UINT32, --num_set_vertex_buffer
	C_UINT32, --num_skip_redundant_vertex_buffer
	C_UINT32, --num_set_index_buffer
	C_UINT32, --num_skip_redundant_index_buffer
	C_UINT32, --num_create_bindgroup
	C_UINT32, --num_discard_bindgroup
	C_UINT32, --num_set_bindgroup
	C_UINT32, --num_skip_redundant_bindgroup
	C_UINT32, --num_bindgroup_cache_hits
	C_UINT32, --num_bindgroup_cache_misses
	C_UINT32, --num_bindgroup_cache_collisions
	C_UINT32, --num_bindgroup_cache_invalidates
	C_UINT32 --num_bindgroup_cache_hash_vs_key_mismatch
})

public constant sg_frame_stats_wgpu = define_c_struct({
	sg_frame_stats_wgpu_uniforms, --uniforms
	sg_frame_stats_wgpu_bindings --bindings
})

public constant sg_frame_stats = define_c_struct({
	C_UINT32, --frame_index
	C_UINT32, --num_passes
	C_UINT32, --num_apply_viewport
	C_UINT32, --num_apply_scissor_rect
	C_UINT32, --num_apply_pipeline
	C_UINT32, --num_apply_bindings
	C_UINT32, --num_apply_uniforms
	C_UINT32, --num_draw
	C_UINT32, --num_dispatch
	C_UINT32, --num_update_buffer
	C_UINT32, --num_append_buffer
	C_UINT32, --num_update_image
	C_UINT32, --size_apply_uniforms
	C_UINT32, --size_update_buffer
	C_UINT32, --size_append_buffer
	C_UINT32, --size_update_image
	sg_frame_stats_gl, --gl
	sg_frame_stats_d3d11, --d3d11
	sg_frame_stats_metal, --metal
	sg_frame_stats_wgpu --wgpu
})

--not wrapped sg_log_item

public constant sg_environment_defaults = define_c_struct({
	C_INT, --color_format
	C_INT --depth_format
})

public constant sg_metal_environment = define_c_struct({
	C_POINTER --device
})

public constant sg_d3d11_environment = define_c_struct({
	C_POINTER, --device
	C_POINTER --device_context
})

public constant sg_wgpu_environment = define_c_struct({
	C_POINTER --device
})

public constant sg_environment = define_c_struct({
	sg_environment_defaults, --defaults
	sg_metal_environment, --metal
	sg_d3d11_environment, --d3d11
	sg_wgpu_environment --wgpu
})

public constant sg_commit_listener = define_c_struct({
	C_POINTER, --func
	C_POINTER --userdata
})

public constant sg_allocator = define_c_struct({
	C_POINTER, --alloc_fn
	C_SIZE_T, --size
	C_POINTER, --user_data
	C_POINTER, --free_fn
	C_POINTER, --user_data
	C_POINTER --user_data
})

public constant sg_logger = define_c_struct({
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

public constant sg_desc = define_c_struct({
	C_UINT32, --start_canary
	C_INT, --buffer_pool_size
	C_INT, --image_pool_size
	C_INT, --sampler_pool_size
	C_INT, --shader_pool_size
	C_INT, --pipeline_pool_size
	C_INT, --attachments_pool_size
	C_INT, --uniform_buffer_size
	C_INT, --max_dispatch_calls_per_pass
	C_INT, --max_commit_listeners
	C_BOOL, --disable_valdiation
	C_BOOL, --d3d11_shader_debugging
	C_BOOL, --mtl_force_managed_storage_mode
	C_BOOL, --mtl_use_command_buffer_with_retained_references
	C_BOOL, --wgpu_disable_bindgroups_cache
	C_INT, --wgpu_bindgroups_cache_size
	sg_allocator, --allocator
	sg_logger, --logger
	C_UINT32 --end_canary
})

public constant xsg_setup = define_c_proc(gfx,"+sg_setup",{C_POINTER})

public procedure sg_setup(atom desc)
	c_proc(xsg_setup,{desc})
end procedure

public constant xsg_shutdown = define_c_proc(gfx,"+sg_shutdown",{})

public procedure sg_shutdown()
	c_proc(xsg_shutdown,{})
end procedure

public constant xsg_isvalid = define_c_func(gfx,"+sg_isvalid",{},C_BOOL)

public function sg_isvalid()
	return c_func(xsg_isvalid,{})
end function

public constant xsg_reset_state_cache = define_c_proc(gfx,"+sg_reset_state_cache",{})

public procedure sg_reset_state_cache()
	c_proc(xsg_reset_state_cache,{})
end procedure

public constant xsg_install_trace_hooks = define_c_func(gfx,"+sg_install_trace_hooks",{C_POINTER},C_POINTER)

public function sg_install_trace_hooks(atom trace_hooks)
	return c_func(xsg_install_trace_hooks,{trace_hooks})
end function

public constant xsg_push_debug_group = define_c_proc(gfx,"+sg_push_debug_group",{C_STRING})

public procedure sg_push_debug_group(sequence name)
	c_proc(xsg_push_debug_group,{name})
end procedure

public constant xsg_pop_debug_group = define_c_proc(gfx,"+sg_pop_debug_group",{})

public procedure sg_pop_debug_group()
	c_proc(xsg_pop_debug_group,{})
end procedure

public constant xsg_add_commit_listener = define_c_func(gfx,"+sg_add_commit_listener",{sg_commit_listener},C_BOOL)

public function sg_add_commit_listener(sequence listener)
	return c_func(xsg_add_commit_listener,{listener})
end function

public constant xsg_remove_commit_listener = define_c_func(gfx,"+sg_remove_commit_listener",{sg_commit_listener},C_BOOL)

public function sg_remove_commit_listener(sequence listener)
	return c_func(xsg_remove_commit_listener,{listener})
end function

public constant xsg_make_buffer = define_c_func(gfx,"+sg_make_buffer",{C_POINTER},sg_buffer)

public function sg_make_buffer(atom desc)
	return c_func(xsg_make_buffer,{desc})
end function

public constant xsg_make_image = define_c_func(gfx,"+sg_make_image",{C_POINTER},sg_image)

public function sg_make_image(atom desc)
	return c_func(xsg_make_image,{desc})
end function

public constant xsg_make_sampler = define_c_func(gfx,"+sg_make_sampler",{C_POINTER},sg_sampler)

public function sg_make_sampler(atom desc)
	return c_func(xsg_make_sampler,{desc})
end function

public constant xsg_make_shader = define_c_func(gfx,"+sg_make_shader",{C_POINTER},sg_shader)

public function sg_make_shader(atom desc)
	return c_func(xsg_make_shader,{desc})
end function

public constant xsg_make_pipeline = define_c_func(gfx,"+sg_make_pipeline",{C_POINTER},sg_pipeline)

public function sg_make_pipeline(atom desc)
	return c_func(xsg_make_pipeline,{desc})
end function

public constant xsg_make_attachments = define_c_func(gfx,"+sg_make_attachments",{C_POINTER},sg_attachments)

public function sg_make_attachments(atom desc)
	return c_func(xsg_make_attachments,{desc})
end function

public constant xsg_destroy_buffer = define_c_proc(gfx,"+sg_destroy_buffer",{sg_buffer})

public procedure sg_destroy_buffer(sequence buf)
	c_proc(xsg_destroy_buffer,{buf})
end procedure

public constant xsg_destroy_image = define_c_proc(gfx,"+sg_destroy_image",{sg_image})

public procedure sg_destroy_image(sequence img)
	c_proc(xsg_destroy_image,{img})
end procedure

public constant xsg_destroy_sampler = define_c_proc(gfx,"+sg_destroy_sampler",{sg_sampler})

public procedure sg_destroy_sampler(sequence smp)
	c_proc(xsg_destroy_sampler,{smp})
end procedure

public constant xsg_destroy_shader = define_c_proc(gfx,"+sg_destroy_shader",{sg_shader})

public procedure sg_destroy_shader(sequence shd)
	c_proc(xsg_destroy_shader,{shd})
end procedure

public constant xsg_destroy_pipeline = define_c_proc(gfx,"+sg_destroy_pipeline",{sg_pipeline})

public procedure sg_destroy_pipeline(sequence pip)
	c_proc(xsg_destroy_pipeline,{pip})
end procedure

public constant xsg_destroy_attachments = define_c_proc(gfx,"+sg_destroy_attachments",{sg_attachments})

public procedure sg_destroy_attachments(sequence atts)
	c_proc(xsg_destroy_attachments,{atts})
end procedure

public constant xsg_update_buffer = define_c_proc(gfx,"+sg_update_buffer",{sg_buffer,C_POINTER})

public procedure sg_update_buffer(sequence buf,atom data)
	c_proc(xsg_update_buffer,{buf,data})
end procedure

public constant xsg_update_image = define_c_proc(gfx,"+sg_update_image",{sg_image,C_POINTER})

public procedure sg_update_image(sequence img,atom data)
	c_proc(xsg_update_image,{img,data})
end procedure

public constant xsg_append_buffer = define_c_func(gfx,"+sg_append_buffer",{sg_buffer,C_POINTER},C_INT)

public function sg_append_buffer(sequence buf,atom data)
	return c_func(xsg_append_buffer,{buf,data})
end function

public constant xsg_query_buffer_overflow = define_c_func(gfx,"+sg_query_buffer_overflow",{sg_buffer},C_BOOL)

public function sg_query_buffer_overflow(sequence buf)
	return c_func(xsg_query_buffer_overflow,{buf})
end function

public constant xsg_query_buffer_will_overflow = define_c_func(gfx,"+sg_query_buffer_will_overflow",{sg_buffer,C_SIZE_T},C_BOOL)

public function sg_query_buffer_will_overflow(sequence buf,atom size)
	return c_func(xsg_query_buffer_will_overflow,{buf,size})
end function

public constant xsg_begin_pass = define_c_proc(gfx,"+sg_begin_pass",{C_POINTER})

public procedure sg_begin_pass(atom pass)
	c_proc(xsg_begin_pass,{pass})
end procedure

public constant xsg_apply_viewport = define_c_proc(gfx,"+sg_apply_viewport",{C_INT,C_INT,C_INT,C_INT,C_BOOL})

public procedure sg_apply_viewport(atom x,atom y,atom width,atom height,atom origin_top_left)
	c_proc(xsg_apply_viewport,{x,y,width,height,origin_top_left})
end procedure

public constant xsg_apply_viewportf = define_c_proc(gfx,"+sg_apply_viewportf",{C_FLOAT,C_FLOAT,C_FLOAT,C_FLOAT,C_BOOL})

public procedure sg_apply_viewportf(atom x,atom y,atom width,atom height,atom origin_top_left)
	c_proc(xsg_apply_viewportf,{x,y,width,height,origin_top_left})
end procedure

public constant xsg_apply_scissor_rect = define_c_proc(gfx,"+sg_apply_scissor_rect",{C_INT,C_INT,C_INT,C_INT,C_BOOL})

public procedure sg_apply_scissor_rect(atom x,atom y,atom width,atom height,atom origin_top_left)
	c_proc(xsg_apply_scissor_rect,{x,y,width,height,origin_top_left})
end procedure

public constant xsg_apply_scissor_rectf = define_c_proc(gfx,"+sg_apply_scissor_rectf",{C_FLOAT,C_FLOAT,C_FLOAT,C_FLOAT,C_BOOL})

public procedure sg_apply_scissor_rectf(atom x,atom y,atom width,atom height,atom origin_top_left)
	c_proc(xsg_apply_scissor_rectf,{x,y,width,height,origin_top_left})
end procedure

public constant xsg_apply_pipeline = define_c_proc(gfx,"+sg_apply_pipeline",{sg_pipeline})

public procedure sg_apply_pipeline(sequence pip)
	c_proc(xsg_apply_pipeline,{pip})
end procedure

public constant xsg_apply_bindings = define_c_proc(gfx,"+sg_apply_bindings",{C_POINTER})

public procedure sg_apply_bindings(atom bindings)
	c_proc(xsg_apply_bindings,{bindings})
end procedure

public constant xsg_apply_uniforms = define_c_proc(gfx,"+sg_apply_uniforms",{C_INT,C_POINTER})

public procedure sg_apply_uniforms(atom ub_slot,atom data)
	c_proc(xsg_apply_uniforms,{ub_slot,data})
end procedure

public constant xsg_draw = define_c_proc(gfx,"+sg_draw",{C_INT,C_INT,C_INT})

public procedure sg_draw(atom base_element,atom num_elements,atom num_instances)
	c_proc(xsg_draw,{base_element,num_elements,num_instances})
end procedure

public constant xsg_dispatch = define_c_proc(gfx,"+sg_dispatch",{C_INT,C_INT,C_INT})

public procedure sg_dispatch(atom num_groups_x,atom num_groups_y,atom num_groups_z)
	c_proc(xsg_dispatch,{num_groups_x,num_groups_y,num_groups_z})
end procedure

public constant xsg_end_pass = define_c_proc(gfx,"+sg_end_pass",{})

public procedure sg_end_pass()
	c_proc(xsg_end_pass,{})
end procedure

public constant xsg_commit = define_c_proc(gfx,"+sg_commit",{})

public procedure sg_commit()
	c_proc(xsg_commit,{})
end procedure

public constant xsg_query_desc = define_c_func(gfx,"+sg_query_desc",{},sg_desc)

public function sg_query_desc()
	return c_func(xsg_query_desc,{})
end function

public constant xsg_query_backend = define_c_func(gfx,"+sg_query_backend",{},C_INT)

public function sg_query_backend()
	return c_func(xsg_query_backend,{})
end function

public constant xsg_query_features = define_c_func(gfx,"+sg_query_features",{},sg_features)

public function sg_query_features()
	return c_func(xsg_query_features,{})
end function

public constant xsg_query_limits = define_c_func(gfx,"+sg_query_limits",{},sg_limits)

public function sg_query_limits()
	return c_func(xsg_query_limits,{})
end function

public constant xsg_query_pixelformat = define_c_func(gfx,"+sg_query_pixelformat",{C_INT},C_INT)

public function sg_query_pixelformat(atom fmt)
	return c_func(xsg_query_pixelformat,{fmt})
end function

public constant xsg_query_row_pitch = define_c_func(gfx,"+sg_query_row_pitch",{C_INT,C_INT,C_INT},C_INT)

public function sg_query_row_pitch(atom fmt,atom width,atom row_align_bytes)
	return c_func(xsg_query_row_pitch,{fmt,width,row_align_bytes})
end function

public constant xsg_query_surface_pitch = define_c_func(gfx,"+sg_query_surface_pitch",{C_INT,C_INT,C_INT,C_INT},C_INT)

public function sg_query_surface_pitch(atom fmt,atom width,atom height,atom row_align_bytes)
	return c_func(xsg_query_surface_pitch,{fmt,width,height,row_align_bytes})
end function

public constant xsg_query_buffer_state = define_c_func(gfx,"+sg_query_buffer_state",{sg_buffer},C_INT)

public function sg_query_buffer_state(sequence buf)
	return c_func(xsg_query_buffer_state,{buf})
end function

public constant xsg_query_image_state = define_c_func(gfx,"+sg_query_image_state",{sg_image},C_INT)

public function sg_query_image_state(sequence img)
	return c_func(xsg_query_image_state,{img})
end function

public constant xsg_query_sampler_state = define_c_func(gfx,"+sg_query_sampler_state",{sg_sampler},C_INT)

public function sg_query_sampler_state(sequence smp)
	return c_func(xsg_query_sampler_state,{smp})
end function

public constant xsg_query_shader_state = define_c_func(gfx,"+sg_query_shader_state",{sg_shader},C_INT)

public function sg_query_shader_state(sequence shd)
	return c_func(xsg_query_shader_state,{shd})
end function

public constant xsg_query_pipeline_state = define_c_func(gfx,"+sg_query_pipeline_state",{sg_pipeline},C_INT)

public function sg_query_pipeline_state(sequence pip)
	return c_func(xsg_query_pipeline_state,{pip})
end function

public constant xsg_query_attachments_state = define_c_func(gfx,"+sg_query_attachments_state",{sg_attachments},C_INT)

public function sg_query_attachments_state(sequence atts)
	return c_func(xsg_query_attachments_state,{atts})
end function

public constant xsg_query_buffer_info = define_c_func(gfx,"+sg_query_buffer_info",{sg_buffer},sg_buffer_info)

public function sg_query_buffer_info(sequence buf)
	return c_func(xsg_query_buffer_info,{buf})
end function

public constant xsg_query_image_info = define_c_func(gfx,"+sg_query_image_info",{sg_image},sg_image_info)

public function sg_query_image_info(sequence img)
	return c_func(xsg_query_image_info,{img})
end function

public constant xsg_query_sampler_info = define_c_func(gfx,"+sg_query_sampler_info",{sg_sampler},sg_sampler_info)

public function sg_query_sampler_info(sequence smp)
	return c_func(xsg_query_sampler_info,{smp})
end function

public constant xsg_query_shader_info = define_c_func(gfx,"+sg_query_shader_info",{sg_shader},sg_shader_info)

public function sg_query_shader_info(sequence shd)
	return c_func(xsg_query_shader_info,{shd})
end function

public constant xsg_query_pipeline_info = define_c_func(gfx,"+sg_query_pipeline_info",{sg_pipeline},sg_pipeline_info)

public function sg_query_pipeline_info(sequence pip)
	return c_func(xsg_query_pipeline_info,{pip})
end function

public constant xsg_query_attachments_info = define_c_func(gfx,"+sg_query_attachments_info",{sg_attachments},sg_attachments_info)

public function sg_query_attachments_info(sequence atts)
	return c_func(xsg_query_attachments_info,{atts})
end function

public constant xsg_query_buffer_desc = define_c_func(gfx,"+sg_query_buffer_desc",{sg_buffer},sg_buffer_desc)

public function sg_query_buffer_desc(sequence buf)
	return c_func(xsg_query_buffer_desc,{buf})
end function

public constant xsg_query_image_desc = define_c_func(gfx,"+sg_query_image_desc",{sg_image},sg_image_desc)

public function sg_query_image_desc(sequence img)
	return c_func(xsg_query_image_desc,{img})
end function

public constant xsg_query_sampler_desc = define_c_func(gfx,"+sg_query_sampler_desc",{sg_sampler},sg_sampler_desc)

public function sg_query_sampler_desc(sequence smp)
	return c_func(xsg_query_sampler_desc,{smp})
end function

public constant xsg_query_shader_desc = define_c_func(gfx,"+sg_query_shader_desc",{sg_shader},sg_shader_desc)

public function sg_query_shader_desc(sequence shd)
	return c_func(xsg_query_shader_desc,{shd})
end function

public constant xsg_query_pipeline_desc = define_c_func(gfx,"+sg_query_pipeline_desc",{sg_pipeline},sg_pipeline_desc)

public function sg_query_pipeline_desc(sequence pip)
	return c_func(xsg_query_pipeline_desc,{pip})
end function

public constant xsg_query_attachments_desc = define_c_func(gfx,"+sg_query_attachments_desc",{sg_attachments},sg_attachments_desc)

public function sg_query_attachments_desc(sequence atts)
	return c_func(xsg_query_attachments_desc,{atts})
end function

public constant xsg_query_buffer_defaults = define_c_func(gfx,"+sg_query_buffer_defaults",{C_POINTER},sg_buffer_desc)

public function sg_query_buffer_defaults(atom desc)
	return c_func(xsg_query_buffer_defaults,{desc})
end function

public constant xsg_query_image_defaults = define_c_func(gfx,"+sg_query_image_defaults",{C_POINTER},sg_image_desc)

public function sg_query_image_defaults(atom desc)
	return c_func(xsg_query_image_defaults,{desc})
end function

public constant xsg_query_sampler_defaults = define_c_func(gfx,"+sg_query_sampler_defaults",{C_POINTER},sg_sampler_desc)

public function sg_query_sampler_defaults(atom desc)
	return c_func(xsg_query_sampler_defaults,{desc})
end function

public constant xsg_query_shader_defaults = define_c_func(gfx,"+sg_query_shader_defaults",{C_POINTER},sg_shader_desc)

public function sg_query_shader_defaults(atom desc)
	return c_func(xsg_query_shader_defaults,{desc})
end function

public constant xsg_query_pipeline_defaults = define_c_func(gfx,"+sg_query_pipeline_defaults",{C_POINTER},sg_pipeline_desc)

public function sg_query_pipeline_defaults(atom desc)
	return c_func(xsg_query_pipeline_defaults,{desc})
end function

public constant xsg_query_attachments_defaults = define_c_func(gfx,"+sg_query_attachments_defaults",{C_POINTER},sg_attachments_desc)

public function sg_query_attachments_defaults(atom desc)
	return c_func(xsg_query_attachments_defaults,{desc})
end function

public constant xsg_query_buffer_size = define_c_func(gfx,"+sg_query_buffer_size",{sg_buffer},C_SIZE_T)

public function sg_query_buffer_size(sequence buf)
	return c_func(xsg_query_buffer_size,{buf})
end function

public constant xsg_query_buffer_type = define_c_func(gfx,"+sg_query_buffer_type",{sg_buffer},C_INT)

public function sg_query_buffer_type(sequence buf)
	return c_func(xsg_query_buffer_type,{buf})
end function

public constant xsg_query_buffer_usage = define_c_func(gfx,"+sg_query_buffer_usage",{sg_buffer},C_INT)

public function sg_query_buffer_usage(sequence buf)
	return c_func(xsg_query_buffer_usage,{buf})
end function

public constant xsg_query_image_type = define_c_func(gfx,"+sg_query_image_type",{sg_image},C_INT)

public function sg_query_image_type(sequence img)
	return c_func(xsg_query_image_type,{img})
end function

public constant xsg_query_image_width = define_c_func(gfx,"+sg_query_image_width",{sg_image},C_INT)

public function sg_query_image_width(sequence img)
	return c_func(xsg_query_image_width,{img})
end function

public constant xsg_query_image_height = define_c_func(gfx,"+sg_query_image_height",{sg_image},C_INT)

public function sg_query_image_height(sequence img)
	return c_func(xsg_query_image_height,{img})
end function

public constant xsg_query_image_num_slices = define_c_func(gfx,"+sg_query_image_num_slices",{sg_image},C_INT)

public function sg_query_image_num_slices(sequence img)
	return c_func(xsg_query_image_num_slices,{img})
end function

public constant xsg_query_image_num_mipmaps = define_c_func(gfx,"+sg_query_image_num_mipmaps",{sg_image},C_INT)

public function sg_query_image_num_mipmaps(sequence img)
	return c_func(xsg_query_image_num_mipmaps,{img})
end function

public constant xsg_query_image_pixelformat = define_c_func(gfx,"+sg_query_image_pixelformat",{sg_image},C_INT)

public function sg_query_image_pixelformat(sequence img)
	return c_func(xsg_query_image_pixelformat,{img})
end function

public constant xsg_query_image_usage = define_c_func(gfx,"+sg_query_image_usage",{sg_image},C_INT)

public function sg_query_image_usage(sequence img)
	return c_func(xsg_query_image_usage,{img})
end function

public constant xsg_query_image_sample_count = define_c_func(gfx,"+sg_query_image_sample_count",{sg_image},C_INT)

public function sg_query_image_sample_count(sequence img)
	return c_func(xsg_query_image_sample_count,{img})
end function

public constant xsg_alloc_buffer = define_c_func(gfx,"+sg_alloc_buffer",{},sg_buffer)

public function sg_alloc_buffer()
	return c_func(xsg_alloc_buffer,{})
end function

public constant xsg_alloc_image = define_c_func(gfx,"+sg_alloc_image",{},sg_image)

public function sg_alloc_image()
	return c_func(xsg_alloc_image,{})
end function

public constant xsg_alloc_sampler = define_c_func(gfx,"+sg_alloc_sampler",{},sg_sampler)

public function sg_alloc_sampler()
	return c_func(xsg_alloc_sampler,{})
end function

public constant xsg_alloc_shader = define_c_func(gfx,"+sg_alloc_shader",{},sg_shader)

public function sg_alloc_shader()
	return c_func(xsg_alloc_shader,{})
end function

public constant xsg_alloc_pipeline = define_c_func(gfx,"+sg_alloc_pipeline",{},sg_pipeline)

public function sg_alloc_pipeline()
	return c_func(xsg_alloc_pipeline,{})
end function

public constant xsg_alloc_attachments = define_c_func(gfx,"+sg_alloc_attachments",{},sg_attachments)

public function sg_alloc_attachments()
	return c_func(xsg_alloc_attachments,{})
end function

public constant xsg_dealloc_buffer = define_c_proc(gfx,"+sg_dealloc_buffer",{sg_buffer})

public procedure sg_dealloc_buffer(sequence buf)
	c_proc(xsg_dealloc_buffer,{buf})
end procedure

public constant xsg_dealloc_image = define_c_proc(gfx,"+sg_dealloc_image",{sg_image})

public procedure sg_dealloc_image(sequence img)
	c_proc(xsg_dealloc_image,{img})
end procedure

public constant xsg_dealloc_sampler = define_c_proc(gfx,"+sg_dealloc_sampler",{sg_sampler})

public procedure sg_dealloc_sampler(sequence smp)
	c_proc(xsg_dealloc_sampler,{smp})
end procedure

public constant xsg_dealloc_shader = define_c_proc(gfx,"+sg_dealloc_shader",{sg_shader})

public procedure sg_dealloc_shader(sequence shd)
	c_proc(xsg_dealloc_shader,{shd})
end procedure

public constant xsg_dealloc_pipeline = define_c_proc(gfx,"+sg_dealloc_pipeline",{sg_pipeline})

public procedure sg_dealloc_pipeline(sequence pip)
	c_proc(xsg_dealloc_pipeline,{pip})
end procedure

public constant xsg_dealloc_attachments = define_c_proc(gfx,"+sg_dealloc_attachments",{sg_attachments})

public procedure sg_dealloc_attachments(sequence attachments)
	c_proc(xsg_dealloc_attachments,{attachments})
end procedure

public constant xsg_init_buffer = define_c_proc(gfx,"+sg_init_buffer",{sg_buffer,C_POINTER})

public procedure sg_init_buffer(sequence buf,atom desc)
	c_proc(xsg_init_buffer,{buf,desc})
end procedure

public constant xsg_init_image = define_c_proc(gfx,"+sg_init_image",{sg_image,C_POINTER})

public procedure sg_init_image(sequence img,atom desc)
	c_proc(xsg_init_image,{img,desc})
end procedure

public constant xsg_init_sampler = define_c_proc(gfx,"+sg_init_sampler",{sg_sampler,C_POINTER})

public procedure sg_init_sampler(sequence smg,atom desc)
	c_proc(xsg_init_sampler,{smg,desc})
end procedure

public constant xsg_init_shader = define_c_proc(gfx,"+sg_init_shader",{sg_shader,C_POINTER})

public procedure sg_init_shader(sequence shd,atom desc)
	c_proc(xsg_init_shader,{shd,desc})
end procedure

public constant xsg_init_pipeline = define_c_proc(gfx,"+sg_init_pipeline",{sg_pipeline,C_POINTER})

public procedure sg_init_pipeline(sequence pip,atom desc)
	c_proc(xsg_init_pipeline,{pip,desc})
end procedure

public constant xsg_init_attachments = define_c_proc(gfx,"+sg_init_attachments",{sg_attachments,C_POINTER})

public procedure sg_init_attachments(sequence attachments,atom desc)
	c_proc(xsg_init_attachments,{attachments,desc})
end procedure

public constant xsg_uninit_buffer = define_c_proc(gfx,"+sg_uninit_buffer",{sg_buffer})

public procedure sg_uninit_buffer(sequence buf)
	c_proc(xsg_uninit_buffer,{buf})
end procedure

public constant xsg_uninit_image = define_c_proc(gfx,"+sg_uninit_image",{sg_image})

public procedure sg_uninit_image(sequence img)
	c_proc(xsg_uninit_image,{img})
end procedure

public constant xsg_uninit_sampler = define_c_proc(gfx,"+sg_uninit_sampler",{sg_sampler})

public procedure sg_uninit_sampler(sequence smp)
	c_proc(xsg_uninit_sampler,{smp})
end procedure

public constant xsg_uninit_shader = define_c_proc(gfx,"+sg_uninit_shader",{sg_shader})

public procedure sg_uninit_shader(sequence shd)
	c_proc(xsg_uninit_shader,{shd})
end procedure

public constant xsg_uninit_pipeline = define_c_proc(gfx,"+sg_uninit_pipeline",{sg_pipeline})

public procedure sg_uninit_pipeline(sequence pip)
	c_proc(xsg_uninit_pipeline,{pip})
end procedure

public constant xsg_uninit_attachments = define_c_proc(gfx,"+sg_uninit_attachments",{sg_attachments})

public procedure sg_uninit_attachments(sequence atts)
	c_proc(xsg_uninit_attachments,{atts})
end procedure

public constant xsg_fail_buffer = define_c_proc(gfx,"+sg_fail_buffer",{sg_buffer})

public procedure sg_fail_buffer(sequence buf)
	c_proc(xsg_fail_buffer,{buf})
end procedure

public constant xsg_fail_image = define_c_proc(gfx,"+sg_fail_image",{sg_image})

public procedure sg_fail_image(sequence img)
	c_proc(xsg_fail_image,{img})
end procedure

public constant xsg_fail_sampler = define_c_proc(gfx,"+sg_fail_sampler",{sg_sampler})

public procedure sg_fail_sampler(sequence smp)
	c_proc(xsg_fail_sampler,{smp})
end procedure

public constant xsg_fail_shader = define_c_proc(gfx,"+sg_fail_shader",{sg_shader})

public procedure sg_fail_shader(sequence shd)
	c_proc(xsg_fail_shader,{shd})
end procedure

public constant xsg_fail_pipeline = define_c_proc(gfx,"+sg_fail_pipeline",{sg_pipeline})

public procedure sg_fail_pipeline(sequence pip)
	c_proc(xsg_fail_pipeline,{pip})
end procedure

public constant xsg_fail_attachments = define_c_proc(gfx,"+sg_fail_attachments",{sg_attachments})

public procedure sg_fail_attachments(sequence atts)
	c_proc(xsg_fail_attachments,{atts})
end procedure

public constant xsg_enable_frame_stats = define_c_proc(gfx,"+sg_enable_frame_stats",{})

public procedure sg_enable_frame_stats()
	c_proc(xsg_enable_frame_stats,{})
end procedure

public constant xsg_disable_frame_stats = define_c_proc(gfx,"+sg_disable_frame_stats",{})

public procedure sg_disable_frame_stats()
	c_proc(xsg_disable_frame_stats,{})
end procedure

public constant xsg_frame_stats_enabled = define_c_func(gfx,"+sg_frame_stats_enabled",{},C_BOOL)

public function sg_frame_stats_enabled()
	return c_func(xsg_frame_stats_enabled,{})
end function

public constant xsg_query_frame_stats = define_c_func(gfx,"+sg_query_frame_stats",{},C_POINTER)

public function sg_query_frame_stats()
	return c_func(xsg_query_frame_stats,{})
end function

public constant sg_d3d11_buffer_info = define_c_struct({
	C_POINTER --buf
})

public constant sg_d3d11_image_info = define_c_struct({
	C_POINTER, --tex2d
	C_POINTER, --tex3d
	C_POINTER, --res
	C_POINTER --srv
})

public constant sg_d3d11_sampler_info = define_c_struct({
	C_POINTER --smp
})

public constant sg_d3d11_shader_info = define_c_struct({
	{C_POINTER,SG_MAX_UNIFORMBLOCK_BINDSLOTS}, --cbufs
	C_POINTER, --vs
	C_POINTER --fs
})

public constant sg_d3d11_pipeline_info = define_c_struct({
	C_POINTER, --il
	C_POINTER, --rs
	C_POINTER, --dss
	C_POINTER --bs
})

public constant sg_d3d11_attachments_info = define_c_struct({
	{C_POINTER,SG_MAX_COLOR_ATTACHMENTS}, --color_rtv
	{C_POINTER,SG_MAX_COLOR_ATTACHMENTS}, --resolve_rtv
	C_POINTER --dsv
})

public constant sg_mtl_buffer_info = define_c_struct({
	{C_POINTER,SG_NUM_INFLIGHT_FRAMES}, --buf
	C_INT --active_slot
})

public constant sg_mtl_image_info = define_c_struct({
	{C_POINTER,SG_NUM_INFLIGHT_FRAMES}, --tex
	C_INT --active_slot
})

public constant sg_mtl_sampler_info = define_c_struct({
	C_POINTER --smp
})

public constant sg_mtl_shader_info = define_c_struct({
	C_POINTER, --vertex_lib
	C_POINTER, --fragment_lib
	C_POINTER, --vertex_func
	C_POINTER --fragment_func
})

public constant sg_mtl_pipeline_info = define_c_struct({
	C_POINTER, --rps
	C_POINTER --dss
})

public constant sg_wgpu_buffer_info = define_c_struct({
	C_POINTER --buf
})

public constant sg_wgpu_image_info = define_c_struct({
	C_POINTER, --tex
	C_POINTER --view
})

public constant sg_wgpu_sampler_info = define_c_struct({
	C_POINTER --smp
})

public constant sg_wgpu_shader_info = define_c_struct({
	C_POINTER, --vs_mod
	C_POINTER, --fs_mod
	C_POINTER --bgl
})

public constant sg_wgpu_pipeline_info = define_c_struct({
	C_POINTER, --render_pipeline
	C_POINTER --compute_pipeline
})

public constant sg_wgpu_attachments_info = define_c_struct({
	{C_POINTER,SG_MAX_COLOR_ATTACHMENTS}, --color_view
	{C_POINTER,SG_MAX_COLOR_ATTACHMENTS}, --resolve_view
	C_POINTER --ds_view
})

public constant sg_gl_buffer_info = define_c_struct({
	{C_UINT32,SG_NUM_INFLIGHT_FRAMES}, --buf
	C_INT --active_slot
})

public constant sg_gl_image_info = define_c_struct({
	{C_UINT32,SG_NUM_INFLIGHT_FRAMES}, --tex
	C_UINT32, --tex_target
	C_UINT32, --msaa_render_buffer
	C_INT --active_slot
})

public constant sg_gl_sampler_info = define_c_struct({
	C_UINT32 --smp
})

public constant sg_gl_shader_info = define_c_struct({
	C_UINT32 --prog
})

public constant sg_gl_attachments_info = define_c_struct({
	C_UINT32, --framebuffer
	{C_UINT32,SG_MAX_COLOR_ATTACHMENTS} --msaa_resolve_framebuffer
})

public constant xsg_d3d11_device = define_c_func(gfx,"+sg_d3d11_device",{},C_POINTER)

public function sg_d3d11_device()
	return c_func(xsg_d3d11_device,{})
end function

public constant xsg_d3d11_device_context = define_c_func(gfx,"+sg_d3d11_device_context",{},C_POINTER)

public function sg_d3d11_device_context()
	return c_func(xsg_d3d11_device_context,{})
end function

public constant xsg_d3d11_query_buffer_info = define_c_func(gfx,"+sg_d3d11_query_buffer_info",{sg_buffer},sg_d3d11_buffer_info)

public function sg_d3d11_query_buffer_info(sequence buf)
	return c_func(xsg_d3d11_query_buffer_info,{buf})
end function

public constant xsg_d3d11_query_image_info = define_c_func(gfx,"+sg_d3d11_query_image_info",{sg_image},sg_d3d11_image_info)

public function sg_d3d11_query_image_info(sequence img)
	return c_func(xsg_d3d11_query_image_info,{img})
end function

public constant xsg_d3d11_query_sampler_info = define_c_func(gfx,"+sg_d3d11_query_sampler_info",{sg_sampler},sg_d3d11_sampler_info)

public function sg_d3d11_query_sampler_info(sequence smp)
	return c_func(xsg_d3d11_query_sampler_info,{smp})
end function

public constant xsg_d3d11_query_shader_info = define_c_func(gfx,"+sg_d3d11_query_shader_info",{sg_shader},sg_d3d11_shader_info)

public function sg_d3d11_query_shader_info(sequence shd)
	return c_func(xsg_d3d11_query_shader_info,{shd})
end function

public constant xsg_d3d11_query_pipeline_info = define_c_func(gfx,"+sg_d3d11_query_pipeline_info",{sg_pipeline},sg_d3d11_pipeline_info)

public function sg_d3d11_query_pipeline_info(sequence pip)
	return c_func(xsg_d3d11_query_pipeline_info,{pip})
end function

public constant xsg_d3d11_query_attachments_info = define_c_func(gfx,"+sg_d3d11_query_attachments_info",{sg_attachments},sg_d3d11_attachments_info)

public function sg_d3d11_query_attachments_info(sequence atts)
	return c_func(xsg_d3d11_query_attachments_info,{atts})
end function

public constant xsg_mtl_device = define_c_func(gfx,"+sg_mtl_device",{},C_POINTER)

public function sg_mtl_device()
	return c_func(xsg_mtl_device,{})
end function

public constant xsg_mtl_render_command_encoder = define_c_func(gfx,"+sg_mtl_render_command_encoder",{},C_POINTER)

public function sg_mtl_render_command_encoder()
	return c_func(xsg_mtl_render_command_encoder,{})
end function

public constant xsg_mtl_compute_command_encoder = define_c_func(gfx,"+sg_mtl_compute_command_encoder",{},C_POINTER)

public function sg_mtl_compute_command_encoder()
	return c_func(xsg_mtl_compute_command_encoder,{})
end function

public constant xsg_mtl_query_buffer_info = define_c_func(gfx,"+sg_mtl_query_buffer_info",{sg_buffer},sg_mtl_buffer_info)

public function sg_mtl_query_buffer_info(sequence buf)
	return c_func(xsg_mtl_query_buffer_info,{buf})
end function

public constant xsg_mtl_query_image_info = define_c_func(gfx,"+sg_mtl_query_image_info",{sg_image},sg_mtl_image_info)

public function sg_mtl_query_image_info(sequence img)
	return c_func(xsg_mtl_query_image_info,{img})
end function

public constant xsg_mtl_query_sampler_info = define_c_func(gfx,"+sg_mtl_query_sampler_info",{sg_sampler},sg_mtl_sampler_info)

public function sg_mtl_query_sampler_info(sequence smp)
	return c_func(xsg_mtl_query_sampler_info,{smp})
end function

public constant xsg_mtl_query_shader_info = define_c_func(gfx,"+sg_mtl_query_shader_info",{sg_shader},sg_mtl_shader_info)

public function sg_mtl_query_shader_info(sequence shd)
	return c_func(xsg_mtl_query_shader_info,{shd})
end function

public constant xsg_mtl_query_pipeline_info = define_c_func(gfx,"+sg_mtl_query_pipeline_info",{sg_pipeline},sg_mtl_pipeline_info)

public function sg_mtl_query_pipeline_info(sequence pip)
	return c_func(xsg_mtl_query_pipeline_info,{pip})
end function

public constant xsg_wgpu_device = define_c_func(gfx,"+sg_wgpu_device",{},C_POINTER)

public function sg_wgpu_device()
	return c_func(xsg_wgpu_device,{})
end function

public constant xsg_wgpu_queue = define_c_func(gfx,"+sg_wgpu_queue",{},C_POINTER)

public function sg_wgpu_queue()
	return c_func(xsg_wgpu_queue,{})
end function

public constant xsg_wgpu_command_encoder = define_c_func(gfx,"+sg_wgpu_command_encoder",{},C_POINTER)

public function sg_wgpu_command_encoder()
	return c_func(xsg_wgpu_command_encoder,{})
end function

public constant xsg_wgpu_render_pass_encoder = define_c_func(gfx,"+sg_wgpu_render_pass_encoder",{},C_POINTER)

public function sg_wgpu_render_pass_encoder()
	return c_func(xsg_wgpu_render_pass_encoder,{})
end function

public constant xsg_wgpu_compute_pass_encoder = define_c_func(gfx,"+sg_wgpu_compute_pass_encoder",{},C_POINTER)

public function sg_wgpu_compute_pass_encoder()
	return c_func(xsg_wgpu_compute_pass_encoder,{})
end function

public constant xsg_wgpu_query_buffer_info = define_c_func(gfx,"+sg_wgpu_query_buffer_info",{sg_buffer},sg_wgpu_buffer_info)

public function sg_wgpu_query_buffer_info(sequence buf)
	return c_func(xsg_wgpu_query_buffer_info,{buf})
end function

public constant xsg_wgpu_query_image_info = define_c_func(gfx,"+sg_wgpu_query_image_info",{sg_image},sg_wgpu_image_info)

public function sg_wgpu_query_image_info(sequence img)
	return c_func(xsg_wgpu_query_image_info,{img})
end function

public constant xsg_wgpu_query_sampler_info = define_c_func(gfx,"+sg_wgpu_query_sampler_info",{sg_sampler},sg_wgpu_sampler_info)

public function sg_wgpu_query_sampler_info(sequence smp)
	return c_func(xsg_wgpu_query_sampler_info,{smp})
end function

public constant xsg_wgpu_query_shader_info = define_c_func(gfx,"+sg_wgpu_query_shader_info",{sg_shader},sg_wgpu_shader_info)

public function sg_wgpu_query_shader_info(sequence shd)
	return c_func(xsg_wgpu_query_shader_info,{shd})
end function

public constant xsg_wgpu_query_pipeline_info = define_c_func(gfx,"+sg_wgpu_query_pipeline_info",{sg_pipeline},sg_wgpu_pipeline_info)

public function sg_wgpu_query_pipeline_info(sequence pip)
	return c_func(xsg_wgpu_query_pipeline_info,{pip})
end function

public constant xsg_wgpu_query_attachments_info = define_c_func(gfx,"+sg_wgpu_query_attachments_info",{sg_attachments},sg_wgpu_attachments_info)

public function sg_wgpu_query_attachments_info(sequence atts)
	return c_func(xsg_wgpu_query_attachments_info,{atts})
end function

public constant xsg_gl_query_buffer_info = define_c_func(gfx,"+sg_gl_query_buffer_info",{sg_buffer},sg_gl_buffer_info)

public function sg_gl_query_buffer_info(sequence buf)
	return c_func(xsg_gl_query_buffer_info,{buf})
end function

public constant xsg_gl_query_image_info = define_c_func(gfx,"+sg_gl_query_image_info",{sg_image},sg_gl_image_info)

public function sg_gl_query_image_info(sequence img)
	return c_func(xsg_gl_query_image_info,{img})
end function

public constant xsg_gl_query_sampler_info = define_c_func(gfx,"+sg_gl_query_sampler_info",{sg_sampler},sg_gl_sampler_info)

public function sg_gl_query_sampler_info(sequence smp)
	return c_func(xsg_gl_query_sampler_info,{smp})
end function

public constant xsg_gl_query_shader_info = define_c_func(gfx,"+sg_gl_query_shader_info",{sg_shader},sg_gl_shader_info)

public function sg_gl_query_shader_info(sequence shd)
	return c_func(xsg_gl_query_shader_info,{shd})
end function

public constant xsg_gl_query_attachments_info = define_c_func(gfx,"+sg_gl_query_attachments_info",{sg_attachments},sg_gl_attachments_info)

public function sg_gl_query_attachments_info(sequence atts)
	return c_func(xsg_gl_query_attachments_info,{atts})
end function
­2075.52