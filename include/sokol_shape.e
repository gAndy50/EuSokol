--SokolShape Wrapper
--Written by Andy P.
--OpenEuphoria wrapper for Sokol Shape library
--Copyright (c) 2025

include std/ffi.e
include std/machine.e
include std/os.e

public atom shape

include sokol_gfx.e

ifdef WINDOWS then
	shape = open_dll("sokol_shape.dll")
	elsifdef LINUX or FREEBSD then
	shape = open_dll("libsokol_shape.so")
	elsifdef OSX then
	shape = open_dll("libsokol_shape.dylib")
end ifdef

if shape = 0 then
	puts(1,"Failed to load sokol_shape!\n")
	abort(0)
end if

public constant sshape_range = define_c_struct({
	C_POINTER, --ptr
	C_SIZE_T --size
})

public constant sshape_mat4_t = define_c_struct({
	{C_FLOAT,4,4} --m[4][4]
})

public constant sshape_vertex_t = define_c_struct({
	C_FLOAT,C_FLOAT,C_FLOAT, --x,y,z
	C_UINT32, --normal
	C_UINT16,C_UINT16, --u,v
	C_UINT32 --color
})

public constant sshape_element_range_t = define_c_struct({
	C_INT, --base_element
	C_INT --num_elements
})

public constant sshape_sizes_item_t = define_c_struct({
	C_UINT32, --num
	C_UINT32 --size
})

public constant sshape_sizes_t = define_c_struct({
	sshape_sizes_item_t, --vertices
	sshape_sizes_item_t --indices
})

public constant sshape_buffer_item_t = define_c_struct({
	sshape_range, --buffer
	C_SIZE_T, --data_size
	C_SIZE_T --shape_offset
})

public constant sshape_buffer_t = define_c_struct({
	C_BOOL, --valid
	sshape_buffer_item_t, --vertices
	sshape_buffer_item_t --indices
})

public constant sshape_plane_t = define_c_struct({
	C_FLOAT,C_FLOAT, --width,height
	C_UINT16, --tiles
	C_UINT32, --color
	C_BOOL, --random_colors
	C_BOOL, --merge
	sshape_mat4_t --transform
})

public constant sshape_box_t = define_c_struct({
	C_FLOAT,C_FLOAT,C_FLOAT, --width,height,depth
	C_UINT16, --tiles
	C_UINT32, --color
	C_BOOL, --random_colors
	C_BOOL, --merge
	sshape_mat4_t --transform
})

public constant sshape_sphere_t = define_c_struct({
	C_FLOAT, --radius
	C_UINT16, --slices
	C_UINT16, --stacks
	C_UINT32, --color
	C_BOOL, --random_colors
	C_BOOL, --merge
	sshape_mat4_t --transform
})

public constant sshape_cylinder_t = define_c_struct({
	C_FLOAT, --radius
	C_FLOAT, --height
	C_UINT16, --slices
	C_UINT16, --stacks
	C_UINT32, --color
	C_BOOL, --random_colors
	C_BOOL, --merge
	sshape_mat4_t --transform
})

public constant sshape_torus_t = define_c_struct({
	C_FLOAT, --radius
	C_FLOAT, --ring_radius
	C_UINT16, --sides
	C_UINT16, --rings
	C_UINT32, --color
	C_BOOL, --random_colors
	C_BOOL, --merge
	sshape_mat4_t --transform
})

public constant xsshape_build_plane = define_c_func(shape,"+sshape_build_plane",{C_POINTER,C_POINTER},sshape_buffer_t)

public function sshape_build_plane(atom buf,atom params)
	return c_func(xsshape_build_plane,{buf,params})
end function

public constant xsshape_build_box = define_c_func(shape,"+sshape_build_box",{C_POINTER,C_POINTER},sshape_buffer_t)

public function sshape_build_box(atom buf,atom params)
	return c_func(xsshape_build_box,{buf,params})
end function

public constant xsshape_build_sphere = define_c_func(shape,"+sshape_build_sphere",{C_POINTER,C_POINTER},sshape_buffer_t)

public function sshape_build_sphere(atom buf,atom params)
	return c_func(xsshape_build_sphere,{buf,params})
end function

public constant xsshape_build_cylinder = define_c_func(shape,"+sshape_build_cylinder",{C_POINTER,C_POINTER},sshape_buffer_t)

public function sshape_build_cylinder(atom buf,atom params)
	return c_func(xsshape_build_cylinder,{buf,params})
end function

public constant xsshape_build_torus = define_c_func(shape,"+sshape_build_torus",{C_POINTER,C_POINTER},sshape_buffer_t)

public function sshape_build_torus(atom buf,atom params)
	return c_func(xsshape_build_torus,{buf,params})
end function

public constant xsshape_plane_sizes = define_c_func(shape,"+sshape_plane_sizes",{C_UINT32},sshape_sizes_t)

public function sshape_plane_sizes(atom tiles)
	return c_func(xsshape_plane_sizes,{tiles})
end function

public constant xsshape_box_sizes = define_c_func(shape,"+sshape_box_sizes",{C_UINT32},sshape_sizes_t)

public function sshape_box_sizes(atom tiles)
	return c_func(xsshape_box_sizes,{tiles})
end function

public constant xsshape_sphere_sizes = define_c_func(shape,"+sshape_sphere_sizes",{C_UINT32,C_UINT32},sshape_sizes_t)

public function sshape_sphere_sizes(atom slices,atom stacks)
	return c_func(xsshape_sphere_sizes,{slices,stacks})
end function

public constant xsshape_cylinder_sizes = define_c_func(shape,"+sshape_cylinder_sizes",{C_UINT32,C_UINT32},sshape_sizes_t)

public function sshape_cylinder_sizes(atom slices,atom stacks)
	return c_func(xsshape_cylinder_sizes,{slices,stacks})
end function

public constant xsshape_torus_sizes = define_c_func(shape,"+sshape_torus_sizes",{C_UINT32,C_UINT32},sshape_sizes_t)

public function sshape_torus_sizes(atom sides,atom rings)
	return c_func(xsshape_torus_sizes,{sides,rings})
end function

public constant xsshape_element_range = define_c_func(shape,"+sshape_element_range",{C_POINTER},sshape_element_range_t)

public function sshape_element_range(atom buf)
	return c_func(xsshape_element_range,{buf})
end function

public constant xsshape_vertex_buffer_desc = define_c_func(shape,"+sshape_vertex_buffer_desc",{C_POINTER},sg_buffer_desc)

public function sshape_vertex_buffer_desc(atom buf)
	return c_func(xsshape_vertex_buffer_desc,{buf})
end function

public constant xsshape_index_buffer_desc = define_c_func(shape,"+sshape_index_buffer_desc",{C_POINTER},sg_buffer_desc)

public function sshape_index_buffer_desc(atom buf)
	return c_func(xsshape_index_buffer_desc,{buf})
end function

public constant xsshape_vertex_buffer_layout_state = define_c_func(shape,"+sshape_vertex_buffer_layout_state",{},C_INT)

public function sshape_vertex_buffer_layout_state()
	return c_func(xsshape_vertex_buffer_layout_state,{})
end function

public constant xsshape_position_vertex_attr_state = define_c_func(shape,"+sshape_position_vertex_attr_state",{},C_INT)

public function sshape_position_vertex_attr_state()
	return c_func(xsshape_position_vertex_attr_state,{})
end function

public constant xsshape_normal_vertex_attr_state = define_c_func(shape,"+sshape_normal_vertex_attr_state",{},C_INT)

public function sshape_normal_vertex_attr_state()
	return c_func(xsshape_normal_vertex_attr_state,{})
end function

public constant xsshape_texcoord_vertex_attr_state = define_c_func(shape,"+sshape_texcoord_vertex_attr_state",{},C_INT)

public function sshape_texcoord_vertex_attr_state()
	return c_func(xsshape_texcoord_vertex_attr_state,{})
end function

public constant xsshape_color_vertex_attr_state = define_c_func(shape,"+sshape_color_vertex_attr_state",{},C_INT)

public function sshape_color_vertex_attr_state()
	return c_func(xsshape_color_vertex_attr_state,{})
end function

public constant xsshape_color_4f = define_c_func(shape,"+sshape_color_4f",{C_FLOAT,C_FLOAT,C_FLOAT,C_FLOAT},C_UINT32)

public function sshape_color_4f(atom r,atom g,atom b,atom a)
	return c_func(xsshape_color_4f,{r,g,b,a})
end function

public constant xsshape_color_3f = define_c_func(shape,"+sshape_color_3f",{C_FLOAT,C_FLOAT,C_FLOAT},C_UINT32)

public function sshape_color_3f(atom r,atom g,atom b)
	return c_func(xsshape_color_3f,{r,g,b})
end function

public constant xsshape_color_4b = define_c_func(shape,"+sshape_color_4b",{C_UINT8,C_UINT8,C_UINT8,C_UINT8},C_UINT32)

public function sshape_color_4b(atom r,atom g,atom b,atom a)
	return c_func(xsshape_color_4b,{r,g,b,a})
end function

public constant xsshape_color_3b = define_c_func(shape,"+sshape_color_3b",{C_UINT8,C_UINT8,C_UINT8},C_UINT32)

public function sshape_color_3b(atom r,atom g,atom b)
	return c_func(xsshape_color_3b,{r,g,b})
end function

public constant xsshape_mat4 = define_c_func(shape,"+sshape_mat4",{C_FLOAT},sshape_mat4_t)

public function sshape_mat4(atom m)
	atom mm = 0
	atom my = allocate_data(sizeof(C_FLOAT) * 16)
	if c_func(xsshape_mat4,{m}) then
		mm = peek_type(my,C_FLOAT)
	end if
	
	free(my)
	
	return mm
end function

public constant xsshape_mat4_transpose = define_c_func(shape,"+sshape_mat4_transpose",{C_FLOAT},sshape_mat4_t)

public function sshape_mat4_transpose(atom m)
	atom mm = 0
	atom my = allocate_data(sizeof(C_FLOAT) * 16)
	if c_func(xsshape_mat4_transpose,{m}) then
		mm = peek_type(my,C_FLOAT)
	end if
	
	free(my)
	
	return mm
end function
­228.89