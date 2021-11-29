@tool
extends EditorPlugin


const MainPanel := preload("res://addons/datalogue/main.tscn")


var main_panel_instance: Control = null


func _enter_tree() -> void:
	main_panel_instance = MainPanel.instantiate()
	get_editor_interface().get_editor_main_control().add_child(main_panel_instance)
	_make_visible(false)


func _exit_tree() -> void:
	if main_panel_instance:
		main_panel_instance.queue_free()


func _make_visible(visibility: bool) -> void:
	if main_panel_instance:
		main_panel_instance.visible = visibility


func _has_main_screen() -> bool:
	return true


func _get_plugin_name() -> String:
	return "Data"


func _get_plugin_icon() -> Texture:
	return load("res://addons/datalogue/assets/datalogue.svg")

