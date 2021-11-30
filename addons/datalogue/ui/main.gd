@tool
extends Control


@onready var _create_dlg: PopupPanel = $CreateDialog
@onready var _create_form: DatalogueCreateForm = $CreateDialog/CreateForm


func _show_create_dialog(title: String) -> void:
	_create_dlg.title = title
	_create_dlg.popup_centered()


func _on_AddDatabaseBtn_pressed():
	_show_create_dialog("Create database")


func _on_CreateDialog_about_to_popup():
	_create_form.clear()


func _on_CreateForm_request_close():
	_create_dlg.hide()
