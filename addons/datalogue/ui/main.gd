@tool
class_name DlUi
extends Control


@onready var _create_dlg: PopupPanel = $CreateDialog
@onready var _create_form: DatalogueCreateForm = $CreateDialog/CreateForm
@onready var _remove_dlg: PopupPanel = $RemoveDialog
@onready var _remove_form: DatalogueRemoveForm = $RemoveDialog/RemoveForm
@onready var _classif_dlg: PopupPanel = $ClassifDialog
@onready var _classif_form: DatalogueClassifForm = $ClassifDialog/ClassifForm
@onready var _db_ui := $Borders/MainLayout/ViewLayout/DatabasesLayout
@onready var _item_ui := $Borders/MainLayout/ViewLayout/ItemsLayout
@onready var _classif_ui := $Borders/MainLayout/ViewLayout/ItemLayout/ClassifLayout


var _object_mode := DlEnums.OBJECT_MODE_DB


func _show_create_dialog(title: String, obj_mode: int, create_mode: int, validation: Callable, origin: String = "") -> void:
	_object_mode = obj_mode
	_create_dlg.title = title
	_create_dlg.popup_centered()
	_create_form.set_mode(create_mode, origin, validation)


func _show_remove_dialog(title: String, mode: int) -> void:
	_object_mode = mode
	_remove_dlg.title = title
	_remove_dlg.popup_centered()


func _show_classif_dialog(title: String, mode: int) -> void:
	_classif_dlg.title = title
	_classif_dlg.popup_centered()


func _on_request_create_form(mode: int) -> void:
	match mode:
		DlEnums.OBJECT_MODE_DB:
			_show_create_dialog("Create a new database", mode, DlEnums.CREATE_MODE_NEW, Datalogue.validate_id)
		DlEnums.OBJECT_MODE_ITEM:
			_show_create_dialog("Create a new item", mode, DlEnums.CREATE_MODE_NEW, _item_ui.validate_id)


func _on_request_copy_form(mode, id) -> void:
	match mode:
		DlEnums.OBJECT_MODE_DB:
			_show_create_dialog("Copy a database", mode, DlEnums.CREATE_MODE_COPY, Datalogue.validate_id, id)
		DlEnums.OBJECT_MODE_ITEM:
			_show_create_dialog("Copy an item", mode, DlEnums.CREATE_MODE_COPY, _item_ui.validate_id, id)


func _on_request_rename_form(mode: int, id: String) -> void:
	match mode:
		DlEnums.OBJECT_MODE_DB:
			_show_create_dialog("Rename a database", mode, DlEnums.CREATE_MODE_RENAME, Datalogue.validate_id, id)
		DlEnums.OBJECT_MODE_ITEM:
			_show_create_dialog("Rename an item", mode, DlEnums.CREATE_MODE_RENAME, _item_ui.validate_id, id)


func _on_request_remove_form(mode: int) -> void:
	match mode:
		DlEnums.OBJECT_MODE_DB:
			_show_remove_dialog("Remove a database", mode)
		DlEnums.OBJECT_MODE_ITEM:
			_show_remove_dialog("Remove an item", mode)


func _on_CreateDialog_about_to_popup() -> void:
	_create_form.clear()


func _on_CreateForm_request_close() -> void:
	_create_dlg.hide()


func _on_CreateForm_submitted(id: String, mode: int, origin: String) -> void:
	match mode:
		DlEnums.CREATE_MODE_NEW:
			match _object_mode:
				DlEnums.OBJECT_MODE_DB:
					print("Create database %s" % id)
					_db_ui.create_database(id)
					_item_ui.clear()
					_classif_ui.clear()
				DlEnums.OBJECT_MODE_ITEM:
					print("Create item %s" % id)
					_item_ui.create_item(id)
					_classif_ui.clear()
		DlEnums.CREATE_MODE_RENAME:
			match _object_mode:
				DlEnums.OBJECT_MODE_DB:
					print("Rename database %s to %s" % [origin, id])
					_db_ui.rename_selected_database(id, origin)
					_item_ui.clear()
					_classif_ui.clear()
				DlEnums.OBJECT_MODE_ITEM:
					print("Rename item %s to %s" % [origin, id])
					_item_ui.rename_selected_item(id, origin)
					_classif_ui.clear()
		DlEnums.CREATE_MODE_COPY:
			match _object_mode:
				DlEnums.OBJECT_MODE_DB:
					print("Copy database %s to %s" % [origin, id])
					_db_ui.copy_selected_database(id)
					_item_ui.clear()
					_classif_ui.clear()
				DlEnums.OBJECT_MODE_ITEM:
					print("Copy item %s to %s" % [origin, id])
					_item_ui.copy_selected_item(id)
					_classif_ui.clear()


func _on_RemoveDialog_about_to_popup() -> void:
	_remove_form.clear()


func _on_RemoveForm_request_close() -> void:
	_remove_dlg.hide()


func _on_RemoveForm_submitted() -> void:
	match _object_mode:
		DlEnums.OBJECT_MODE_DB:
			print("Remove database %s" % _db_ui.selected_id())
			_db_ui.delete_selected()
			_item_ui.clear()
			_classif_ui.clear()
		DlEnums.OBJECT_MODE_ITEM:
			print("Remove item %s" % _item_ui.selected_id())
			_item_ui.delete_selected()
			_classif_ui.clear()


func _on_request_classif_form(mode: int) -> void:
	_show_classif_dialog("Create a new classification", mode)


func _on_ClassifDialog_about_to_popup() -> void:
	_classif_form.clear()


func _on_ClassifForm_request_close() -> void:
	_classif_dlg.hide()


func _on_ClassifForm_submitted() -> void:
	pass
