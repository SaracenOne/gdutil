tool

static func test_point_with_planes(p_point, p_planes):
	for plane in p_planes:
		if(plane.is_point_over(p_point)):
			return false
	return true

static func test_aabb_with_planes(p_aabb, p_planes):
	for plane in p_planes:
		if(plane.is_point_over(p_aabb.pos) and plane.is_point_over(p_aabb.end)):
			return false
	return true
	
static func get_cylinder_boundings_box(p_pos, p_cylinder):
	return AABB(p_pos, Vector3(p_cylinder.get_radius(), p_cylinder.get_height() * 0.5, p_cylinder.get_radius()))
	
static func get_sphere_boundings_box(p_pos, p_sphere):
	return AABB(p_pos, Vector3(p_sphere.get_radius(), p_sphere.get_radius(), p_sphere.get_radius()))
