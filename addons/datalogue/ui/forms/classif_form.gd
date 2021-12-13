@tool
class_name DatalogueClassifForm
extends Control


signal request_close()
signal submitted(id: String, values: Array[String], mode: int, origin: String)


@onready var _id_edit := $MainLayout/IdEdit
@onready var _value_edit := $MainLayout/InputLayout/ValueEdit
@onready var _value_list := $MainLayout/ValueLayout/ValueList
@onready var _add_value_btn := $MainLayout/InputLayout/AddValueBtn
@onready var _remove_value_btn := $MainLayout/ValueLayout/ValueTools/RemoveValueBtn
@onready var _error_lbl := $MainLayout/ErrorLbl
@onready var _create_btn := $MainLayout/ButtonLayout/CreateBtn


var _mode := DlEnums.FORM_MODE_NEW
var _validation := _default_validation
var _selected := -1
var _origin := ""


func clear() -> void:
	_create_btn.disabled = true
	_add_value_btn.disabled = true
	_remove_value_btn.disabled = true
	_id_edit.text = ""
	_value_edit.text = ""
	_value_list.clear()
	_error_lbl.text = ""
	_selected = -1


func set_mode(mode: int, validation: Callable, origin: String, values: Array) -> void:
	_mode = mode
	_validation = validation
	_origin = origin
	
	_id_edit.text = origin
	
	for value in values:
		_value_list.add_item(value)
	
	match mode:
		DlEnums.FORM_MODE_NEW:
			_create_btn.text = "Create"
		DlEnums.FORM_MODE_MODIFY:
			_create_btn.text = "Modify"
		DlEnums.FORM_MODE_COPY:
			_create_btn.text = "Duplicate"


func _submit() -> void:
	_error_lbl.text = ""
	
	var values :=  _values_to_array()
	var error := _validation.call(_id_edit.text, values, _mode, _origin) as String
	if not error.is_empty():
		_error_lbl.text = error
	else:
		emit_signal("submitted", _id_edit.text, values, _mode, _origin)
		emit_signal("request_close")


func _add_value() -> void:
	if not _add_value_btn.disabled:
		_value_list.add_item(_value_edit.text)
		_value_list.deselect_all()
		_selected = -1
		_value_edit.text = ""
		_add_value_btn.disabled = true
		_remove_value_btn.disabled = true
		_update_create_btn()


func _update_create_btn() -> void:
	if _id_edit.text.is_empty() or _value_list.item_count <= 0:
		_create_btn.disabled = true
	elif _mode == DlEnums.FORM_MODE_COPY and _id_edit.text == _origin:
		_create_btn.disabled = true
	else:
		_create_btn.disabled = false


func _values_to_array() -> Array[String]:
	var result: Array[String]
	
	for i in range(_value_list.item_count):
		result.append(_value_list.get_item_text(i))
	
	return result


func _default_validation(id: String, values: Array[String], mode: int, origin: String) -> String:
	return "Internal error"


func _on_CreateBtn_pressed() -> void:
	_submit()


func _on_CancelBtn_pressed() -> void:
	emit_signal("request_close")


func _on_IdEdit_text_changed(new_text: String) -> void:
	_update_create_btn()


func _on_IdEdit_text_submitted(new_text: String) -> void:
	if not _create_btn.disabled:
		_submit()


func _on_IdEdit_text_change_rejected(rejected_substring: String) -> void:
	emit_signal("request_close")


func _on_ValueEdit_text_changed(new_text: String) -> void:
	if new_text.is_empty():
		_add_value_btn.disabled = true
	else:
		_add_value_btn.disabled = false


func _on_ValueEdit_text_submitted(new_text: String) -> void:
	if new_text.is_empty() and not _create_btn.disabled:
		_submit()
	else:
		_add_value()


func _on_AddValueBtn_pressed() -> void:
	_add_value()


func _on_ValueEdit_text_change_rejected(rejected_substring: String) -> void:
	_value_edit.text = ""
	_add_value_btn.disabled = true


func _on_ValueList_item_selected(index: int) -> void:
	_selected = index
	if _selected >= 0:
		_remove_value_btn.disabled = false
	else:
		_remove_value_btn.disabled = true


func _on_RemoveValueBtn_pressed() -> void:
	if _selected >= 0:
		_value_list.remove_item(_selected)
		_remove_value_btn.disabled = true
		_selected = -1
		_update_create_btn()
