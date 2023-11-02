@tool
extends EditorPlugin


const MAIN_FOLDER := "res://_datalogue"
const MainPanel := preload("res://addons/datalogue/ui/main.tscn")


var main_panel_instance: Control = null


func _enter_tree() -> void:
	add_autoload_singleton("Datalogue", "res://addons/datalogue/core/datalogue.gd")

	var dir := DirAccess.open("res://")
	if not dir.dir_exists(MAIN_FOLDER):
		dir.make_dir_recursive(MAIN_FOLDER)

	main_panel_instance = MainPanel.instantiate()
	get_editor_interface().get_editor_main_screen().add_child(main_panel_instance)

	_make_visible(false)


func _exit_tree() -> void:
	if main_panel_instance:
		main_panel_instance.queue_free()

	remove_autoload_singleton("Datalogue")


func _make_visible(visibility: bool) -> void:
	if main_panel_instance:
		main_panel_instance.visible = visibility


func _has_main_screen() -> bool:
	return true


func _get_plugin_name() -> String:
	return "Data"


func _get_plugin_icon() -> Texture2D:
	return load("res://addons/datalogue/ui/assets/datalogue.svg")

