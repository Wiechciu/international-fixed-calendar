@tool
extends EditorPlugin


const autoload_name: String = "IFC"
const autoload_script_path: String = "res://addons/international_fixed_calendar/ifc_autoload.gd"


func _enable_plugin() -> void:
	var script: Script = get_script()
	if script:
		add_autoload_singleton(autoload_name, autoload_script_path)


func _disable_plugin() -> void:
	remove_autoload_singleton(autoload_name)
