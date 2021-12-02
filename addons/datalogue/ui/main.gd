@tool
class_name DatalogueUi
extends Control


enum {CREATE_MODE_DB, CREATE_MODE_ITEM, CREATE_MODE_CLASSIF, CREATE_MODE_VALUE, CREATE_MODE_TEXT}
enum {REMOVE_MODE_DB, REMOVE_MODE_ITEM, REMOVE_MODE_CLASSIF, REMOVE_MODE_VALUE, REMOVE_MODE_TEXT}


@onready var _create_dlg: PopupPanel = $CreateDialog
@onready var _create_form: DatalogueCreateForm = $CreateDialog/CreateForm
@onready var _remove_dlg: PopupPanel = $RemoveDialog
@onready var _remove_form: DatalogueRemoveForm = $RemoveDialog/RemoveForm
@onready var _db_ui := $Borders/MainLayout/ViewLayout/DatabasesLayout
@onready var _item_ui := $Borders/MainLayout/ViewLayout/ItemsLayout


var _create_mode := CREATE_MODE_DB
var _remove_mode := REMOVE_MODE_DB


func _show_create_dialog(title: String, mode: int) -> void:
	_create_mode = mode
	_create_dlg.title = title
	_create_dlg.popup_centered()


func _show_remove_dialog(title: String, mode: int) -> void:
	_remove_mode = mode
	_remove_dlg.title = title
	_remove_dlg.popup_centered()


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


func _on_request_remove_form(mode: int) -> void:
	match mode:
		REMOVE_MODE_DB:
			_show_remove_dialog("Remove a database", mode)
		REMOVE_MODE_ITEM:
			_show_remove_dialog("Remove a item", mode)
		REMOVE_MODE_CLASSIF:
			_show_remove_dialog("Remove a classification", mode)
		REMOVE_MODE_VALUE:
			_show_remove_dialog("Remove a value", mode)
		REMOVE_MODE_TEXT:
			_show_remove_dialog("Remove a text", mode)


func _on_CreateDialog_about_to_popup() -> void:
	_create_form.clear()


func _on_CreateForm_request_close() -> void:
	_create_dlg.hide()


func _on_CreateForm_submitted(id: String) -> void:
	match _create_mode:
		CREATE_MODE_DB:
			Datalogue.create_database(DatalogueDb.new(id))
		CREATE_MODE_ITEM:
			_item_ui.create_item(id)
		CREATE_MODE_CLASSIF:
			pass
		CREATE_MODE_VALUE:
			pass
		CREATE_MODE_TEXT:
			pass


func _on_RemoveDialog_about_to_popup() -> void:
	_remove_form.clear()


func _on_RemoveForm_request_close() -> void:
	_remove_dlg.hide()


func _on_RemoveForm_submitted() -> void:
	match _create_mode:
		REMOVE_MODE_DB:
			_db_ui.delete_selected()
		REMOVE_MODE_ITEM:
			pass
		REMOVE_MODE_CLASSIF:
			pass
		REMOVE_MODE_VALUE:
			pass
		REMOVE_MODE_TEXT:
			pass
