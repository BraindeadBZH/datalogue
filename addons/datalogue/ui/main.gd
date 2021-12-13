@tool
class_name DlUi
extends Control


@onready var _create_dlg := $CreateDialog
@onready var _create_form := $CreateDialog/CreateForm
@onready var _remove_dlg := $RemoveDialog
@onready var _remove_form := $RemoveDialog/RemoveForm
@onready var _classif_dlg := $ClassifDialog
@onready var _classif_form := $ClassifDialog/ClassifForm
@onready var _value_dlg := $ValueDialog
@onready var _value_form := $ValueDialog/ValueForm
@onready var _text_dlg := $TextDialog
@onready var _text_form := $TextDialog/TextForm
@onready var _db_ui := $Borders/MainLayout/ViewLayout/DatabasesLayout
@onready var _items_ui := $Borders/MainLayout/ViewLayout/ItemsLayout
@onready var _classif_ui := $Borders/MainLayout/ViewLayout/ItemLayout/ClassifLayout
@onready var _values_ui := $Borders/MainLayout/ViewLayout/ItemLayout/ValuesLayout
@onready var _texts_ui := $Borders/MainLayout/ViewLayout/ItemLayout/TextsLayout


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


func _show_classif_dialog(title: String, mode: int, origin: String, values: Array) -> void:
	_classif_dlg.title = title
	_classif_dlg.popup_centered()
	_classif_form.set_mode(mode, _items_ui.validate_classification, origin, values)


func _show_value_dialog(title: String, mode: int, origin: String, value: float) -> void:
	_value_dlg.title = title
	_value_dlg.popup_centered()
	_value_form.set_mode(mode, _items_ui.validate_value, origin, value)


func _show_text_dialog(title: String, mode: int, origin: String, text: String) -> void:
	_text_dlg.title = title
	_text_dlg.popup_centered()
	_text_form.set_mode(mode, _items_ui.validate_text, origin, text)


func _on_request_create_form(mode: int) -> void:
	match mode:
		DlEnums.OBJECT_MODE_DB:
			_show_create_dialog("Create a new database", mode, DlEnums.FORM_MODE_NEW, Datalogue.validate_id)
		DlEnums.OBJECT_MODE_ITEM:
			_show_create_dialog("Create a new item", mode, DlEnums.FORM_MODE_NEW, _items_ui.validate_id)


func _on_request_copy_form(mode, id) -> void:
	match mode:
		DlEnums.OBJECT_MODE_DB:
			_show_create_dialog("Copy a database", mode, DlEnums.FORM_MODE_COPY, Datalogue.validate_id, id)
		DlEnums.OBJECT_MODE_ITEM:
			_show_create_dialog("Copy an item", mode, DlEnums.FORM_MODE_COPY, _items_ui.validate_id, id)


func _on_request_rename_form(mode: int, id: String) -> void:
	match mode:
		DlEnums.OBJECT_MODE_DB:
			_show_create_dialog("Rename a database", mode, DlEnums.FORM_MODE_MODIFY, Datalogue.validate_id, id)
		DlEnums.OBJECT_MODE_ITEM:
			_show_create_dialog("Rename an item", mode, DlEnums.FORM_MODE_MODIFY, _items_ui.validate_id, id)


func _on_request_remove_form(mode: int) -> void:
	match mode:
		DlEnums.OBJECT_MODE_DB:
			_show_remove_dialog("Remove a database", mode)
		DlEnums.OBJECT_MODE_ITEM:
			_show_remove_dialog("Remove an item", mode)
		DlEnums.OBJECT_MODE_CLASSIF:
			_show_remove_dialog("Remove a classification", mode)
		DlEnums.OBJECT_MODE_VALUE:
			_show_remove_dialog("Remove a value", mode)
		DlEnums.OBJECT_MODE_TEXT:
			_show_remove_dialog("Remove a text", mode)


func _on_CreateDialog_about_to_popup() -> void:
	_create_form.clear()


func _on_CreateForm_request_close() -> void:
	_create_dlg.hide()


func _on_CreateForm_submitted(id: String, mode: int, origin: String) -> void:
	match mode:
		DlEnums.FORM_MODE_NEW:
			match _object_mode:
				DlEnums.OBJECT_MODE_DB:
					print("Create database %s" % id)
					_db_ui.create_database(id)
					_items_ui.clear()
					_classif_ui.clear()
					_values_ui.clear()
					_texts_ui.clear()
				DlEnums.OBJECT_MODE_ITEM:
					print("Create item %s" % id)
					_items_ui.create_item(id)
					_classif_ui.clear()
					_values_ui.clear()
					_texts_ui.clear()
		DlEnums.FORM_MODE_MODIFY:
			match _object_mode:
				DlEnums.OBJECT_MODE_DB:
					print("Rename database %s to %s" % [origin, id])
					_db_ui.rename_selected_database(id, origin)
					_items_ui.clear()
					_classif_ui.clear()
					_values_ui.clear()
					_texts_ui.clear()
				DlEnums.OBJECT_MODE_ITEM:
					print("Rename item %s to %s" % [origin, id])
					_items_ui.rename_selected_item(id, origin)
					_classif_ui.clear()
					_values_ui.clear()
					_texts_ui.clear()
		DlEnums.FORM_MODE_COPY:
			match _object_mode:
				DlEnums.OBJECT_MODE_DB:
					print("Copy database %s to %s" % [origin, id])
					_db_ui.copy_selected_database(id)
					_items_ui.clear()
					_classif_ui.clear()
					_values_ui.clear()
					_texts_ui.clear()
				DlEnums.OBJECT_MODE_ITEM:
					print("Copy item %s to %s" % [origin, id])
					_items_ui.copy_selected_item(id)
					_classif_ui.clear()
					_values_ui.clear()
					_texts_ui.clear()


func _on_RemoveDialog_about_to_popup() -> void:
	_remove_form.clear()


func _on_RemoveForm_request_close() -> void:
	_remove_dlg.hide()


func _on_RemoveForm_submitted() -> void:
	match _object_mode:
		DlEnums.OBJECT_MODE_DB:
			print("Remove database %s" % _db_ui.selected_id())
			_db_ui.delete_selected()
			_items_ui.clear()
			_classif_ui.clear()
			_values_ui.clear()
			_texts_ui.clear()
		DlEnums.OBJECT_MODE_ITEM:
			print("Remove item %s" % _items_ui.selected_id())
			_items_ui.delete_selected()
			_classif_ui.clear()
			_values_ui.clear()
			_texts_ui.clear()
		DlEnums.OBJECT_MODE_CLASSIF:
			print("Remove classification %s" % _classif_ui.selected_id())
			_classif_ui.delete_selected()
		DlEnums.OBJECT_MODE_VALUE:
			print("Remove value %s" % _values_ui.selected_id())
			_values_ui.delete_selected()
		DlEnums.OBJECT_MODE_TEXT:
			print("Remove text %s" % _texts_ui.selected_id())
			_texts_ui.delete_selected()


func _on_request_classif_form(mode: int, origin: String, values: Array) -> void:
	match mode:
		DlEnums.FORM_MODE_NEW:
			_show_classif_dialog("Create a new classification", mode, origin, values)
		DlEnums.FORM_MODE_MODIFY:
			_show_classif_dialog("Modify a classification", mode, origin, values)
		DlEnums.FORM_MODE_COPY:
			_show_classif_dialog("Copy a classification", mode, origin, values)


func _on_ClassifDialog_about_to_popup() -> void:
	_classif_form.clear()


func _on_ClassifForm_request_close() -> void:
	_classif_dlg.hide()


func _on_ClassifForm_submitted(id: String, values: Array[String], mode: int, origin: String) -> void:
	match mode:
		DlEnums.FORM_MODE_NEW:
			print("Create classification %s with value(s) " % id, values)
			_classif_ui.create_classif(id, values)
		DlEnums.FORM_MODE_MODIFY:
			if id != origin:
				print("Modify classification from %s to %s with value(s) " % [origin, id], values)
			else:
				print("Modify classification %s with value(s) " % id, values)
			_classif_ui.modify_selected(id, values)
		DlEnums.FORM_MODE_COPY:
			print("Copy classification %s to %s with value(s) " % [origin, id], values)
			_classif_ui.copy_selected(id, values)


func _on_request_value_form(mode: int, origin: String, value: float) -> void:
	match mode:
		DlEnums.FORM_MODE_NEW:
			_show_value_dialog("Create a new value", mode, origin, value)
		DlEnums.FORM_MODE_MODIFY:
			_show_value_dialog("Modify a value", mode, origin, value)
		DlEnums.FORM_MODE_COPY:
			_show_value_dialog("Copy a value", mode, origin, value)


func _on_ValueDialog_about_to_popup() -> void:
	_value_form.clear()


func _on_ValueForm_request_close() -> void:
	_value_dlg.hide()


func _on_ValueForm_submitted(id: String, value: float, mode: int, origin: String) -> void:
	match mode:
		DlEnums.FORM_MODE_NEW:
			print("Create value %s with %f " % [id, value])
			_values_ui.create_value(id, value)
		DlEnums.FORM_MODE_MODIFY:
			if id != origin:
				print("Modify value from %s to %s with %f " % [origin, id, value])
			else:
				print("Modify value %s with %f " % [id, value])
			_values_ui.modify_selected(id, value)
		DlEnums.FORM_MODE_COPY:
			print("Copy value %s to %s with %f " % [origin, id, value])
			_values_ui.copy_selected(id, value)


func _on_request_text_form(mode: int, origin: String, text: String) -> void:
	match mode:
		DlEnums.FORM_MODE_NEW:
			_show_text_dialog("Create a new text", mode, origin, text)
		DlEnums.FORM_MODE_MODIFY:
			_show_text_dialog("Modify a text", mode, origin, text)
		DlEnums.FORM_MODE_COPY:
			_show_text_dialog("Copy a text", mode, origin, text)


func _on_TextDialog_about_to_popup() -> void:
	_text_form.clear()


func _on_TextForm_request_close() -> void:
	_text_dlg.hide()


func _on_TextForm_submitted(id: String, text: String, mode: int, origin: String) -> void:
	match mode:
		DlEnums.FORM_MODE_NEW:
			print("Create text %s with %s " % [id, text])
			_texts_ui.create_text(id, text)
		DlEnums.FORM_MODE_MODIFY:
			if id != origin:
				print("Modify text from %s to %s with %s " % [origin, id, text])
			else:
				print("Modify text %s with %s " % [id, text])
			_texts_ui.modify_selected(id, text)
		DlEnums.FORM_MODE_COPY:
			print("Copy text %s to %s with %s " % [origin, id, text])
			_texts_ui.copy_selected(id, text)
