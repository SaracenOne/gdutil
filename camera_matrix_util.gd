tool
var matrix = set_identity()

func set_identity():
	matrix = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
	
static func get_fovy(p_fovx ,p_aspect):
	return rad2deg(atan(p_aspect * tan(deg2rad(p_fovx) * 0.5)) * 2.0)

func get_endpoints():
	# Near Plane
	var near_plane=Plane(matrix[ 3] + matrix[ 2],
	                matrix[ 7] + matrix[ 6],
	                matrix[11] + matrix[10],
			-matrix[15] - matrix[14]).normalized()

	# Far Plane
	var far_plane=Plane(matrix[ 2] - matrix[ 3],
		      matrix[ 6] - matrix[ 7],
		      matrix[10] - matrix[11],
		      matrix[15] - matrix[14]).normalized()


	# Right Plane
	var right_plane=Plane(matrix[ 0] - matrix[ 3],
	                matrix[ 4] - matrix[ 7],
	                matrix[8] - matrix[ 11],
			- matrix[15] + matrix[12]).normalized()

	# Top Plane
	var top_plane=Plane(matrix[ 1] - matrix[ 3],
	                matrix[ 5] - matrix[ 7],
	                matrix[9] - matrix[ 11],
			-matrix[15] + matrix[13]).normalized()

	var near_endpoint = near_plane.intersect_3(right_plane,top_plane)
	var far_endpoint = far_plane.intersect_3(right_plane,top_plane)
	
	var points_8 = []

	points_8.push_back(Vector3(near_endpoint.x, near_endpoint.y, near_endpoint.z))
	points_8.push_back(Vector3( near_endpoint.x,-near_endpoint.y, near_endpoint.z))
	points_8.push_back(Vector3(-near_endpoint.x, near_endpoint.y, near_endpoint.z))
	points_8.push_back(Vector3(-near_endpoint.x,-near_endpoint.y, near_endpoint.z))
	points_8.push_back(Vector3( far_endpoint.x, far_endpoint.y, far_endpoint.z))
	points_8.push_back(Vector3( far_endpoint.x,-far_endpoint.y, far_endpoint.z))
	points_8.push_back(Vector3(-far_endpoint.x, far_endpoint.y, far_endpoint.z))
	points_8.push_back(Vector3(-far_endpoint.x,-far_endpoint.y, far_endpoint.z))

	return points_8

func get_projection_planes(p_transform):
	var planes = []
	var new_plane
	
	# Near Plane
	new_plane=Plane(matrix[3] + matrix[2],
		      matrix[7] + matrix[6],
		      matrix[11] + matrix[10],
		      matrix[15] + matrix[14])
		
	new_plane.normal = -new_plane.normal
	new_plane = new_plane.normalized()
	
	planes.push_back(p_transform.xform(new_plane))
	
	# Far Plane
	new_plane=Plane(matrix[3] - matrix[2],
		      matrix[7] - matrix[6],
		      matrix[11] - matrix[10],
		      matrix[15] - matrix[14])
		
	new_plane.normal = -new_plane.normal
	new_plane = new_plane.normalized()
	
	planes.push_back(p_transform.xform(new_plane))
	
	# Left Plane
	new_plane=Plane(matrix[3] + matrix[0],
		      matrix[7] + matrix[4],
		      matrix[11] + matrix[8],
		      matrix[15] + matrix[12])
		
	new_plane.normal = -new_plane.normal
	new_plane = new_plane.normalized()
	
	planes.push_back(p_transform.xform(new_plane))
	
	# Top Plane
	new_plane=Plane(matrix[ 3] - matrix[1],
		      matrix[7] - matrix[5],
		      matrix[11] - matrix[9],
		      matrix[15] - matrix[13])
		
	new_plane.normal = -new_plane.normal
	new_plane = new_plane.normalized()
	
	planes.push_back(p_transform.xform(new_plane))
	
	# Right Plane
	new_plane=Plane(matrix[3] - matrix[0],
		      matrix[7] - matrix[4],
		      matrix[11] - matrix[8],
		      matrix[15] - matrix[12])
		
	new_plane.normal = -new_plane.normal
	new_plane = new_plane.normalized()
	
	planes.push_back(p_transform.xform(new_plane))
	
	# Bottom Plane
	new_plane=Plane(matrix[ 3] + matrix[ 1],
		      matrix[7] + matrix[5],
		      matrix[11] + matrix[9],
		      matrix[15] + matrix[13])
		
	new_plane.normal = -new_plane.normal
	new_plane = new_plane.normalized()
	
	planes.push_back(p_transform.xform(new_plane))
	
	return planes
	
func set_perspective(p_fovy_degrees, p_aspect, p_z_near, p_z_far, p_flip_fov):
	if (p_flip_fov):
		p_fovy_degrees = get_fovy(p_fovy_degrees, 1.0 / p_aspect)

	var sine
	var cotangent
	var delta_z
	var radians = p_fovy_degrees / 2.0 * PI / 180.0

	delta_z = p_z_far - p_z_near
	sine = sin(radians)

	if ((delta_z == 0) || (sine == 0) || (p_aspect == 0)):
		return
		
	cotangent = cos(radians) / sine

	set_identity()

	matrix[0] = cotangent / p_aspect
	matrix[5] = cotangent
	matrix[10] = -(p_z_far + p_z_near) / delta_z
	matrix[11] = -1
	matrix[14] = -2 * p_z_near * p_z_far / delta_z
	matrix[15] = 0
	
func set_orthogonal(p_left, p_right, p_bottom, p_top,  p_znear, p_zfar):
	set_identity()

	matrix[0] = 2.0/(p_right-p_left)
	matrix[12] = -((p_right+p_left)/(p_right-p_left))
	matrix[5] = 2.0/(p_top-p_bottom)
	matrix[13] = -((p_top+p_bottom)/(p_top-p_bottom))
	matrix[10] = -2.0/(p_zfar-p_znear)
	matrix[14] = -((p_zfar+p_znear)/(p_zfar-p_znear))
	matrix[15] = 1.0
	
func test_point(p_planes, p_point):
	for camera_plane in p_planes:
		if(camera_plane.is_point_over(p_point)):
			return false
			
	return true
	
func test_rect3(p_planes, p_rect3):
	if(test_point(p_planes, p_rect3.pos) == false and test_point(p_planes, p_rect3.end) == false):
		return false
	else:
		return true