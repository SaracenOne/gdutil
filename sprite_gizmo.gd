extends EditorSpatialGizmo

const immediate_shape_util_const = preload("immediate_shape_util.gd")

var plugin = null
var icon = Texture()

func get_handle_name(p_idx):
	return ""

func get_handle_value(p_idx):
	return 0

func set_handle(p_idx, p_spatial, p_point):
	pass

func commit_handle(p_idx, p_restore, p_cancel):
	pass

func redraw():
	clear()
	var icon_material = immediate_shape_util_const.create_icon_material("icon_material", texture)
	add_unscaled_billboard(icon_material, 0.05);

func _init(p_plugin, p_texture):
	texture = p_texture
	plugin = p_plugin
	set_spatial_node(camera)
