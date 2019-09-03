tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("ConnectionUtil", "res://addons/gdutil/connection_util.gd")
	
func _exit_tree() -> void:
	remove_autoload_singleton("ConnectionUtil")
