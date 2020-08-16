tool
extends EditorPlugin

func _init():
	print("Initialising GDUtil plugin")


func _notification(p_notification: int):
	match p_notification:
		NOTIFICATION_PREDELETE:
			print("Destroying GDUtil plugin")


func get_name() -> String:
	return "GDUtil"


func _enter_tree() -> void:
	add_autoload_singleton("ConnectionUtil", "res://addons/gdutil/connection_util.gd")


func _exit_tree() -> void:
	remove_autoload_singleton("ConnectionUtil")
