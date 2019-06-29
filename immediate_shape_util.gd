tool

static func create_icon_material(p_texture, p_albedo):
	var color = p_albedo

	var icon = SpatialMaterial.new()
	icon.set_flag(SpatialMaterial.FLAG_UNSHADED, true)
	icon.set_cull_mode(SpatialMaterial.CULL_DISABLED)
	icon.set_depth_draw_mode(SpatialMaterial.DEPTH_DRAW_DISABLED)
	icon.set_feature(SpatialMaterial.FEATURE_TRANSPARENT, true)
	icon.set_albedo(color)
	icon.set_texture(SpatialMaterial.TEXTURE_ALBEDO, p_texture)
	icon.set_flag(SpatialMaterial.FLAG_FIXED_SIZE, true)
	icon.set_billboard_mode(SpatialMaterial.BILLBOARD_ENABLED)

	return icon

static func create_debug_material(p_color):
	var material = SpatialMaterial.new()
	
	material.params_depth_draw_mode = SpatialMaterial.DEPTH_DRAW_ALWAYS
	
	material.flags_unshaded = true
	material.flags_transparent = true
	material.set_flag(SpatialMaterial.FLAG_SRGB_VERTEX_COLOR, true)
	material.set_flag(SpatialMaterial.FLAG_ALBEDO_FROM_VERTEX_COLOR, true)
	material.set_albedo(p_color)
	
	#material.flags_no_depth_test = true
	
	return material

static func create_debug_immediate():
	var immediate_geometry = ImmediateGeometry.new()
	immediate_geometry.set_cast_shadows_setting(GeometryInstance.SHADOW_CASTING_SETTING_OFF)
	immediate_geometry.set_flag(GeometryInstance.FLAG_RECEIVE_SHADOWS, false)
	
	var material = create_debug_material(Color(1.0, 1.0, 1.0))
	
	immediate_geometry.set_material_override(material)
	return immediate_geometry

static func immediate_cube(p_rect3, p_immediate_geometry):
	p_immediate_geometry.begin(Mesh.PRIMITIVE_LINES)
	
	var rect3_min = p_rect3.position
	var rect3_max = p_rect3.end
	
	p_immediate_geometry.add_vertex(Vector3(rect3_min.x, rect3_min.y, rect3_min.z))
	p_immediate_geometry.add_vertex(Vector3(rect3_min.x, rect3_max.y, rect3_min.z))
	
	p_immediate_geometry.add_vertex(Vector3(rect3_min.x, rect3_min.y, rect3_min.z))
	p_immediate_geometry.add_vertex(Vector3(rect3_max.x, rect3_min.y, rect3_min.z))
	
	p_immediate_geometry.add_vertex(Vector3(rect3_min.x, rect3_max.y, rect3_min.z))
	p_immediate_geometry.add_vertex(Vector3(rect3_max.x, rect3_max.y, rect3_min.z))
	
	p_immediate_geometry.add_vertex(Vector3(rect3_max.x, rect3_min.y, rect3_min.z))
	p_immediate_geometry.add_vertex(Vector3(rect3_max.x, rect3_max.y, rect3_min.z))
	
	p_immediate_geometry.add_vertex(Vector3(rect3_max.x, rect3_min.y, rect3_min.z))
	p_immediate_geometry.add_vertex(Vector3(rect3_max.x, rect3_min.y, rect3_max.z))
	
	p_immediate_geometry.add_vertex(Vector3(rect3_max.x, rect3_max.y, rect3_min.z))
	p_immediate_geometry.add_vertex(Vector3(rect3_max.x, rect3_max.y, rect3_max.z))
	
	p_immediate_geometry.add_vertex(Vector3(rect3_max.x, rect3_min.y, rect3_max.z))
	p_immediate_geometry.add_vertex(Vector3(rect3_max.x, rect3_max.y, rect3_max.z))
	
	p_immediate_geometry.add_vertex(Vector3(rect3_max.x, rect3_min.y, rect3_max.z))
	p_immediate_geometry.add_vertex(Vector3(rect3_min.x, rect3_min.y, rect3_max.z))
	
	p_immediate_geometry.add_vertex(Vector3(rect3_max.x, rect3_max.y, rect3_max.z))
	p_immediate_geometry.add_vertex(Vector3(rect3_min.x, rect3_max.y, rect3_max.z))
	
	p_immediate_geometry.add_vertex(Vector3(rect3_min.x, rect3_min.y, rect3_max.z))
	p_immediate_geometry.add_vertex(Vector3(rect3_min.x, rect3_max.y, rect3_max.z))
	
	p_immediate_geometry.add_vertex(Vector3(rect3_min.x, rect3_min.y, rect3_max.z))
	p_immediate_geometry.add_vertex(Vector3(rect3_min.x, rect3_min.y, rect3_min.z))
	
	p_immediate_geometry.add_vertex(Vector3(rect3_min.x, rect3_max.y, rect3_max.z))
	p_immediate_geometry.add_vertex(Vector3(rect3_min.x, rect3_max.y, rect3_min.z))
	
	p_immediate_geometry.end()

static func immediate_camera_frustum(p_camera_matrix, p_immediate_geometry):
	var end_points = p_camera_matrix.get_endpoints()
	
	p_immediate_geometry.begin(Mesh.PRIMITIVE_LINES)
	# Near
	p_immediate_geometry.add_vertex(end_points[0])
	p_immediate_geometry.add_vertex(end_points[2])
	
	p_immediate_geometry.add_vertex(end_points[2])
	p_immediate_geometry.add_vertex(end_points[3])
	
	p_immediate_geometry.add_vertex(end_points[3])
	p_immediate_geometry.add_vertex(end_points[1])
	
	p_immediate_geometry.add_vertex(end_points[1])
	p_immediate_geometry.add_vertex(end_points[0])
	
	#Far
	p_immediate_geometry.add_vertex(end_points[4])
	p_immediate_geometry.add_vertex(end_points[6])
	
	p_immediate_geometry.add_vertex(end_points[6])
	p_immediate_geometry.add_vertex(end_points[7])
	
	p_immediate_geometry.add_vertex(end_points[7])
	p_immediate_geometry.add_vertex(end_points[5])
	
	p_immediate_geometry.add_vertex(end_points[5])
	p_immediate_geometry.add_vertex(end_points[4])
	
	# Connection
	p_immediate_geometry.add_vertex(end_points[0])
	p_immediate_geometry.add_vertex(end_points[4])
	
	p_immediate_geometry.add_vertex(end_points[1])
	p_immediate_geometry.add_vertex(end_points[5])
	
	p_immediate_geometry.add_vertex(end_points[2])
	p_immediate_geometry.add_vertex(end_points[6])
	
	p_immediate_geometry.add_vertex(end_points[3])
	p_immediate_geometry.add_vertex(end_points[7])
	
	p_immediate_geometry.end()
