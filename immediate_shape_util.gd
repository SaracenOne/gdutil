tool

static func create_debug_immediate(p_skip_depth_test=false):
	var immediate_geometry = ImmediateGeometry.new()
	immediate_geometry.set_cast_shadows_setting(GeometryInstance.SHADOW_CASTING_SETTING_OFF)
	immediate_geometry.set_flag(GeometryInstance.FLAG_RECEIVE_SHADOWS, false)
	
	var material = FixedMaterial.new()
	material.set_fixed_flag(FixedMaterial.FLAG_USE_ALPHA, true)
	material.set_flag(Material.FLAG_UNSHADED, true)
	material.set_depth_draw_mode(Material.DEPTH_DRAW_NEVER)
	if p_skip_depth_test:
		material.set_depth_test_mode(Material.DEPTH_TEST_MODE_ALWAYS)
	
	immediate_geometry.set_material_override(material)
	return immediate_geometry

static func immediate_cube(p_rect3, p_immediate_geometry):
	p_immediate_geometry.begin(Mesh.PRIMITIVE_LINES)
	
	var rect3_min = p_rect3.pos
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