@tool
class_name DatalogueUi
extends Control


enum {OBJECT_MODE_DB, OBJECT_MODE_ITEM}


@onready var _create_dlg: PopupPanel = $CreateDialog
@onready var _create_form: DatalogueCreateForm = $CreateDialog/CreateForm
@onready var _remove_dlg: PopupPanel = $RemoveDialog
@onready var _remove_form: DatalogueRemoveForm = $RemoveDialog/RemoveForm
@onready var _db_ui := $Borders/MainLayout/ViewLayout/DatabasesLayout
@onready var _item_ui := $Borders/MainLayout/ViewLayout/ItemsLayout


var _object_mode := OBJECT_MODE_DB


func _show_create_dialog(title: String, obj_mode: int, create_mode: int, origin: String = "") -> void:
	_object_mode = obj_mode
	_create_dlg.title = title
	_create_dlg.popup_centered()
	_create_form.set_mode(create_mode, origin)


func _show_remove_dialog(title: String, mode: int) -> void:
	_object_mode = mode
	_remove_dlg.title = title
	_remove_dlg.popup_centered()


func _on_request_create_form(mode: int) -> void:
	match mode:
		OBJECT_MODE_DB:
			_show_create_dialog("Create a new database", mode, DatalogueCreateForm.CREATE_MODE_NEW)
		OBJECT_MODE_ITEM:
			_show_create_dialog("Create a new item", mode, DatalogueCreateForm.CREATE_MODE_NEW)


func _on_request_rename_form(mode: int, id: String) -> void:
	match mode:
		OBJECT_MODE_DB:
			_show_create_dialog("Rename a database", mode, DatalogueCreateForm.CREATE_MODE_RENAME, id)
		OBJECT_MODE_ITEM:
			_show_create_dialog("Rename a item", mode, DatalogueCreateForm.CREATE_MODE_RENAME, id)


func _on_request_remove_form(mode: int) -> void:
	match mode:
		OBJECT_MODE_DB:
			_show_remove_dialog("Remove a database", mode)
		OBJECT_MODE_ITEM:
			_show_remove_dialog("Remove a item", mode)


func _on_CreateDialog_about_to_popup() -> void:
	_create_form.clear()


func _on_CreateForm_request_close() -> void:
	_create_dlg.hide()


func _on_CreateForm_submitted(id: String, mode: int, origin: String) -> void:
	match mode:
		DatalogueCreateForm.CREATE_MODE_NEW:
			match _object_mode:
				OBJECT_MODE_DB:
					print("Create database")
					_db_ui.create_database(id)
					_item_ui.clear()
				OBJECT_MODE_ITEM:
					print("Create item")
					_item_ui.create_item(id)
		DatalogueCreateForm.CREATE_MODE_RENAME:
			match _object_mode:
				OBJECT_MODE_DB:
					print("Rename database %s to %s" % [origin, id])
					_db_ui.rename_selected_database(id, origin)
					_item_ui.clear()
				OBJECT_MODE_ITEM:
					print("Rename item %s to %s" % [origin, id])
					_item_ui.rename_selected_item(id, origin)
		DatalogueCreateForm.CREATE_MODE_COPY:
			match _object_mode:
				OBJECT_MODE_DB:
					print("Copy database %s to %s" % [origin, id])
				OBJECT_MODE_ITEM:
					print("Copy item %s to %s" % [origin, id])


func _on_RemoveDialog_about_to_popup() -> void:
	_remove_form.clear()


func _on_RemoveForm_request_close() -> void:
	_remove_dlg.hide()


func _on_RemoveForm_submitted() -> void:
	match _object_mode:
		OBJECT_MODE_DB:
			print("Remove database")
			_db_ui.delete_selected()
			_item_ui.clear()
		OBJECT_MODE_ITEM:
			print("Remove item")
			_item_ui.delete_selected()
