@tool
extends Control


enum {CREATE_MODE_DB, CREATE_MODE_ITEM, CREATE_MODE_CLASSIF, CREATE_MODE_VALUE, CREATE_MODE_TEXT}


@onready var _create_dlg: PopupPanel = $CreateDialog
@onready var _create_form: DatalogueCreateForm = $CreateDialog/CreateForm


var _create_mode := CREATE_MODE_DB


func _show_create_dialog(title: String) -> void:
	_create_dlg.title = title
	_create_dlg.popup_centered()


func _on_AddDatabaseBtn_pressed():
	_show_create_dialog("Create database")
	_create_mode = CREATE_MODE_DB


func _on_CreateDialog_about_to_popup():
	_create_form.clear()


func _on_CreateForm_request_close():
	_create_dlg.hide()


func _on_CreateForm_submitted(id):
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
