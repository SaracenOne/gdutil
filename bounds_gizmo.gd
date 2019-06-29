extends EditorSpatialGizmo

const immediate_shape_util_const = preload("immediate_shape_util.gd")

var plugin = null
var spatial = null
var color = Color()

func get_handle_name(p_idx):
	if p_idx == 0:
		return "X"
	elif p_idx == 1:
		return "Y"
	elif p_idx == 2:
		return "Z"

	return ""
		
func get_handle_value(p_idx):
	return spatial.get_bounds().size * 2
		
func set_handle(p_idx, p_camera, p_point):
	var gt = spatial.get_global_transform()
	gt = gt.orthonormalized()
	var gi = gt.affine_inverse()
	
	var aabb = spatial.get_bounds()
	var ray_from = p_camera.project_ray_origin(p_point)
	var ray_dir = p_camera.project_ray_normal(p_point)

	var sg = [gi.xform(ray_from), gi.xform(ray_from + ray_dir * 4096)]
	var ofs = aabb.position + aabb.size * 0.5

	var axis = Vector3()
	axis[p_idx] = 1.0;
		
	var result = Geometry.get_closest_points_between_segments(ofs, ofs + axis * 4096, sg[0], sg[1])
	var ra = result[0]
	var rb = result[1]

	var d = ra[p_idx]
	if (d < 0.001):
		d = 0.001
		
	aabb.position[p_idx] = (aabb.position[p_idx] + aabb.size[p_idx] * 0.5) - d
	aabb.size[p_idx] = d * 2
	spatial.set_bounds(aabb)
		
func commit_handle(p_idx, p_restore, p_cancel = false):
	if (p_cancel):
		spatial.set_bonuds(p_restore) # !
		return

	var ur = plugin.get_undo_redo()
	ur.create_action(tr("Change Box Shape Bounds"))
	ur.add_do_method(spatial, "set_bounds", spatial.get_bounds())
	ur.add_undo_method(spatial, "set_bounds", p_restore) # !
	ur.commit_action()
		
static func get_lines(p_bounds):
	var lines = PoolVector3Array()
	
	var rect3_min = p_bounds.position
	var rect3_max = p_bounds.end
	
	lines.append(Vector3(rect3_min.x, rect3_min.y, rect3_min.z))
	lines.append(Vector3(rect3_min.x, rect3_max.y, rect3_min.z))
	
	lines.append(Vector3(rect3_min.x, rect3_min.y, rect3_min.z))
	lines.append(Vector3(rect3_max.x, rect3_min.y, rect3_min.z))
	
	lines.append(Vector3(rect3_min.x, rect3_max.y, rect3_min.z))
	lines.append(Vector3(rect3_max.x, rect3_max.y, rect3_min.z))
	
	lines.append(Vector3(rect3_max.x, rect3_min.y, rect3_min.z))
	lines.append(Vector3(rect3_max.x, rect3_max.y, rect3_min.z))
	
	lines.append(Vector3(rect3_max.x, rect3_min.y, rect3_min.z))
	lines.append(Vector3(rect3_max.x, rect3_min.y, rect3_max.z))
	
	lines.append(Vector3(rect3_max.x, rect3_max.y, rect3_min.z))
	lines.append(Vector3(rect3_max.x, rect3_max.y, rect3_max.z))
	
	lines.append(Vector3(rect3_max.x, rect3_min.y, rect3_max.z))
	lines.append(Vector3(rect3_max.x, rect3_max.y, rect3_max.z))
	
	lines.append(Vector3(rect3_max.x, rect3_min.y, rect3_max.z))
	lines.append(Vector3(rect3_min.x, rect3_min.y, rect3_max.z))
	
	lines.append(Vector3(rect3_max.x, rect3_max.y, rect3_max.z))
	lines.append(Vector3(rect3_min.x, rect3_max.y, rect3_max.z))
	
	lines.append(Vector3(rect3_min.x, rect3_min.y, rect3_max.z))
	lines.append(Vector3(rect3_min.x, rect3_max.y, rect3_max.z))
	
	lines.append(Vector3(rect3_min.x, rect3_min.y, rect3_max.z))
	lines.append(Vector3(rect3_min.x, rect3_min.y, rect3_min.z))
	
	lines.append(Vector3(rect3_min.x, rect3_max.y, rect3_max.z))
	lines.append(Vector3(rect3_min.x, rect3_max.y, rect3_min.z))
	
	return lines
		
func redraw():
	clear()

	var material = immediate_shape_util_const.create_debug_material(color)

	var bounds = spatial.get_bounds()
	var lines = get_lines(bounds)
	
	var handles = PoolVector3Array()
	
	for i in range(0, 3):
		var ax = Vector3()
		ax[i] = bounds.position[i] + bounds.size[i]
		handles.push_back(ax)
		
	add_lines(lines, material)
	add_collision_segments(lines)
	add_handles(handles, material)
	
func _init(p_spatial, p_plugin, p_color):
	spatial = p_spatial
	plugin = p_plugin
	color = p_color
	
	set_spatial_node(spatial)
