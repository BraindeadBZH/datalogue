@tool
class_name DatalogueRemoveForm
extends Control


signal request_close()
signal submitted()


@onready var _validate_sw := $MainLayout/ValidateSw
@onready var _delete_btn := $MainLayout/ButtonLayout/DeleteBtn


func clear() -> void:
	_validate_sw.pressed = false


func _on_ValidateSw_toggled(button_pressed: bool) -> void:
	_delete_btn.disabled = not button_pressed


func _on_CancelBtn_pressed() -> void:
	emit_signal("request_close")


func _on_DeleteBtn_pressed() -> void:
	emit_signal("submitted")
	emit_signal("request_close")
