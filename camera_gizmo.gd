extends EditorSpatialGizmo

const immediate_shape_util_const = preload("immediate_shape_util.gd")

var plugin = null
var camera = null
var material = Color()

static func _find_closest_angle_to_half_pi_arc(p_from, p_to, p_arc_radius, p_arc_xform):
	var arc_test_points=64
	var min_d = 1e20
	var min_p

	for i in range(0, arc_test_points):
		var a = i * PI * 0.5 / arc_test_points
		var an = (i + 1) * PI * 0.5/arc_test_points
		var p = Vector3(cos(a), 0, -sin(a)) * p_arc_radius
		var n = Vector3(cos(an), 0,- sin(an)) * p_arc_radius

		var r = Geometry.get_closest_points_between_segments(p, n, p_from, p_to)
		var ra = r[0]
		var rb = r[1]

		var d = ra.distance_to(rb)
		if(d < min_d):
			min_d=d
			min_p=ra

	var a = Vector2(min_p.x, -min_p.z).angle()
	return a * 180.0 / PI

func get_handle_name(p_idx):
	return "FOV"

func get_handle_value(p_idx):
	return camera.get_fov()

func set_handle(p_idx, p_camera, p_point):
	var gt = camera.get_global_transform()
	gt = gt.orthonormalized()
	var gi = gt.affine_inverse()

	var ray_from = p_camera.project_ray_origin(p_point)
	var ray_dir = p_camera.project_ray_normal(p_point)

	var s = [gi.xform(ray_from), gi.xform(ray_from + ray_dir * 4096)]

	gt = camera.get_global_transform()
	var a = _find_closest_angle_to_half_pi_arc(s[0], s[1], 1.0, gt)
	camera.set("fov", a);
	camera.property_list_changed_notify()

func commit_handle(p_idx, p_restore, p_cancel = false):
	if (p_cancel):
		camera.set("fov", p_restore)
	else:
		var ur = plugin.get_undo_redo()
		ur.create_action("Change Camera FOV")
		ur.add_do_property(camera, "fov", camera.get_fov())
		ur.add_undo_property(camera, "fov", p_restore)
		ur.commit_action()
	camera.property_list_changed_notify()

func add_triangle(p_lines, m_a, m_b, m_c):
	p_lines.push_back(m_a)
	p_lines.push_back(m_b)
	p_lines.push_back(m_b)
	p_lines.push_back(m_c)
	p_lines.push_back(m_c)
	p_lines.push_back(m_a)

	return p_lines

func redraw():
	clear()
	var lines = []
	var handles = []

	var fov = camera.get_fov()

	var side = Vector3(sin(deg2rad(fov)), 0, -cos(deg2rad(fov)))
	var nside = side
	nside.x = -nside.x
	var up = Vector3(0, side.x, 0)

	lines = add_triangle(lines, Vector3(), side + up, side - up)
	lines = add_triangle(lines, Vector3(), nside + up, nside - up)
	lines = add_triangle(lines, Vector3(), side + up, nside + up)
	lines = add_triangle(lines, Vector3(), side - up, nside - up)

	handles.push_back(side)
	side.x *= 0.25
	nside.x *= 0.25
	var tup = Vector3(0, up.y * 3 / 2, side.z)
	lines = add_triangle(lines, tup, side + up, nside + up)

	add_lines(lines, material)
	add_collision_segments(lines)
	add_handles(handles, material)

func _init(p_camera, p_plugin, p_color):
	camera = p_camera
	plugin = p_plugin
	set_spatial_node(camera)
	material = immediate_shape_util_const.create_debug_material(p_color)
