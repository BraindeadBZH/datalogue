@tool
class_name DatalogueCreateForm
extends Control


signal request_close()
signal submitted(id: String, mode: int, origin: String)


@onready var _id_edit := $MainLayout/IdEdit
@onready var _error_lbl := $MainLayout/ErrorLbl
@onready var _create_btn := $MainLayout/ButtonLayout/CreateBtn


var _mode := DlEnums.FORM_MODE_NEW
var _origin := ""
var _validation := _default_validation


func clear() -> void:
	_create_btn.disabled = true
	_clear_field()
	_clear_error()


func set_mode(mode: int, origin: String, validation: Callable = _default_validation) -> void:
	_mode = mode
	_origin = origin
	_id_edit.text = origin
	_validation = validation
	
	match mode:
		DlEnums.FORM_MODE_NEW:
			_create_btn.text = "Create"
		DlEnums.FORM_MODE_MODIFY:
			_create_btn.text = "Rename"
		DlEnums.FORM_MODE_COPY:
			_create_btn.text = "Duplicate"


func _clear_field() -> void:
	_id_edit.text = ""


func _clear_error() -> void:
	_error_lbl.text = ""


func _submit() -> void:
	_clear_error()
	
	var error := _validation.call(_id_edit.text) as String
	if not error.is_empty():
		_error_lbl.text = error
	else:
		emit_signal("submitted", _id_edit.text, _mode, _origin)
		emit_signal("request_close")


func _default_validation() -> String:
	return "Internal error"


func _on_CreateBtn_pressed() -> void:
	_submit()


func _on_CancelBtn_pressed() -> void:
	emit_signal("request_close")


func _on_IdEdit_text_changed(new_text) -> void:
	if new_text.is_empty() or new_text == _origin:
		_create_btn.disabled = true
	else:
		_create_btn.disabled = false


func _on_IdEdit_text_change_rejected(rejected_substring: String) -> void:
	emit_signal("request_close")


func _on_IdEdit_text_submitted(new_text: String) -> void:
	_submit()
