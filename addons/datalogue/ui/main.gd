@tool
class_name DatalogueUi
extends Control


enum {CREATE_MODE_DB, CREATE_MODE_ITEM, CREATE_MODE_CLASSIF, CREATE_MODE_VALUE, CREATE_MODE_TEXT}


@onready var _create_dlg: PopupPanel = $CreateDialog
@onready var _create_form: DatalogueCreateForm = $CreateDialog/CreateForm


var _create_mode := CREATE_MODE_DB


func _show_create_dialog(title: String, mode: int) -> void:
	_create_mode = mode
	_create_dlg.title = title
	_create_dlg.popup_centered()


func _on_request_create_form(mode: int) -> void:
	match mode:
		CREATE_MODE_DB:
			_show_create_dialog("Create a new database", mode)
		CREATE_MODE_ITEM:
			_show_create_dialog("Create a new item", mode)
		CREATE_MODE_CLASSIF:
			_show_create_dialog("Create a new classification", mode)
		CREATE_MODE_VALUE:
			_show_create_dialog("Create a new value", mode)
		CREATE_MODE_TEXT:
			_show_create_dialog("Create a new text", mode)


func _on_CreateDialog_about_to_popup() -> void:
	_create_form.clear()


func _on_CreateForm_request_close() -> void:
	_create_dlg.hide()


func _on_CreateForm_submitted(id) -> void:
	match _create_mode:
		CREATE_MODE_DB:
			Datalogue.create_database(DatalogueDb.new(id))
		CREATE_MODE_ITEM:
			pass
		CREATE_MODE_CLASSIF:
			pass
		CREATE_MODE_VALUE:
			pass
		CREATE_MODE_TEXT:
			pass
