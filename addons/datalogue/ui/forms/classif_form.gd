@tool
class_name DatalogueClassifForm
extends Control


signal request_close()
signal submitted()


@onready var _id_edit: LineEdit = $MainLayout/IdEdit
@onready var _classif_list: ItemList = $MainLayout/ListLayout/ClassifList
@onready var _error_lbl: Label = $MainLayout/ErrorLbl
@onready var _create_btn: Button = $MainLayout/ButtonLayout/CreateBtn


func clear() -> void:
	_create_btn.disabled = true
	_id_edit.text = ""
	_classif_list.clear()
	_error_lbl.text = ""


func _on_CreateBtn_pressed() -> void:
	emit_signal("submitted")
	emit_signal("request_close")


func _on_CancelBtn_pressed() -> void:
	emit_signal("request_close")
