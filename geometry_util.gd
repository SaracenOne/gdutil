tool

static func test_rect3_with_planes(p_rect3, p_planes):
	for plane in p_planes:
		if(plane.is_point_over(p_rect3.pos) and plane.is_point_over(p_rect3.end)):
			return false
	return true
	
static func get_cylinder_boundings_box(p_pos, p_cylinder):
	return AABB(p_pos, Vector3(p_cylinder.get_radius(), p_cylinder.get_height() * 0.5, p_cylinder.get_radius()))