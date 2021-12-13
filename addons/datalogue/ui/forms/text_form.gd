@tool
class_name DatalogueTextForm
extends Control


signal request_close()
signal submitted(id: String, text: String, mode: int, origin: String)


@onready var _id_edit := $MainLayout/IdEdit
@onready var _text_edit := $MainLayout/TextEdit
@onready var _error_lbl := $MainLayout/ErrorLbl
@onready var _create_btn := $MainLayout/ButtonLayout/CreateBtn


var _mode := DlEnums.FORM_MODE_NEW
var _validation := _default_validation
var _origin := ""
var _saved_text := ""


func clear() -> void:
	_create_btn.disabled = true
	_id_edit.text = ""
	_text_edit.text = ""
	_error_lbl.text = ""


func set_mode(mode: int, validation: Callable, origin: String, text: String) -> void:
	_mode = mode
	_validation = validation
	_origin = origin
	_saved_text = text
	
	_id_edit.text = origin
	_text_edit.text = text
	
	match mode:
		DlEnums.FORM_MODE_NEW:
			_create_btn.text = "Create"
		DlEnums.FORM_MODE_MODIFY:
			_create_btn.text = "Modify"
		DlEnums.FORM_MODE_COPY:
			_create_btn.text = "Duplicate"


func _submit() -> void:
	_error_lbl.text = ""
	
	var error := _validation.call(_id_edit.text, _mode, _origin) as String
	if not error.is_empty():
		_error_lbl.text = error
	else:
		emit_signal("submitted", _id_edit.text, _text_edit.text, _mode, _origin)
		emit_signal("request_close")


func _update_create_btn() -> void:
	if _id_edit.text.is_empty():
		_create_btn.disabled = true
	elif _mode == DlEnums.FORM_MODE_COPY and _id_edit.text == _origin:
		_create_btn.disabled = true
	elif _mode == DlEnums.FORM_MODE_MODIFY and _id_edit.text == _origin and _text_edit.text == _saved_text: 
		_create_btn.disabled = true
	else:
		_create_btn.disabled = false


func _default_validation(id: String, mode: int, origin: String) -> String:
	return "Internal error"


func _on_IdEdit_text_changed(new_text: String) -> void:
	_update_create_btn()


func _on_IdEdit_text_submitted(new_text: String) -> void:
	if not _create_btn.disabled:
		_submit()


func _on_IdEdit_text_change_rejected(rejected_substring: String) -> void:
	emit_signal("request_close")


func _on_TextEdit_text_changed() -> void:
	_update_create_btn()


func _on_CreateBtn_pressed() -> void:
	_submit()


func _on_CancelBtn_pressed() -> void:
	emit_signal("request_close")
