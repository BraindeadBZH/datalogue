@tool
class_name DatalogueCreateForm
extends Control


signal request_close()
signal submitted(id: String, old_id: String)


@onready var _id_edit: LineEdit = $MainLayout/IdEdit
@onready var _error_lbl: Label = $MainLayout/ErrorLbl
@onready var _create_btn: Button = $MainLayout/ButtonLayout/CreateBtn

var _old_id := ""


func clear() -> void:
	_create_btn.disabled = true
	_clear_field()
	_clear_error()


func set_old_id(id: String) -> void:
	_old_id = id
	_id_edit.text = id
	if id.is_empty():
		_create_btn.text = "Create"
	else:
		_create_btn.text = "Rename"


func _clear_field() -> void:
	_id_edit.text = ""


func _clear_error() -> void:
	_error_lbl.text = ""


func _on_CreateBtn_pressed() -> void:
	_clear_error()
	
	var error := Datalogue.validate_id(_id_edit.text)
	if not error.is_empty():
		_error_lbl.text = error
	else:
		emit_signal("submitted", _id_edit.text, _old_id)
		emit_signal("request_close")


func _on_CancelBtn_pressed() -> void:
	emit_signal("request_close")


func _on_IdEdit_text_changed(new_text) -> void:
	if new_text.is_empty() or new_text == _old_id:
		_create_btn.disabled = true
	else:
		_create_btn.disabled = false
