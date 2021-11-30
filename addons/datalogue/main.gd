@tool
extends Control


@onready var _create_dlg: PopupPanel = $CreateDialog


func _on_AddDatabaseBtn_pressed():
	_create_dlg.popup_centered()
