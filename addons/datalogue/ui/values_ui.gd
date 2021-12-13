@tool
extends HBoxContainer


signal request_value_form(mode: int, origin: String, value: float)
signal request_remove_form(mode: int)


@onready var _value_list := $ValueList
@onready var _add_btn := $ValuesTools/AddValueBtn
@onready var _dup_btn := $ValuesTools/DupValueBtn
@onready var _delete_btn := $ValuesTools/RemoveValueBtn


var _selected_db: DlDatabase = null
var _selected_item: DlItem = null
var _selected_value := ""


func clear() -> void:
	if _selected_item != null:
		_selected_item.disconnect("changed", Callable(self, "_on_item_changed"))
		_selected_item = null
	
	_value_list.clear()
	_selected_value = ""
	
	_add_btn.disabled = true
	_dup_btn.disabled = true
	_delete_btn.disabled = true


func selected_id() -> String:
	return _selected_value


func create_value(id: String, value: float) -> void:
	if _selected_db != null and _selected_item != null:
		_selected_item.add_value(id, value)
		Datalogue.update_database(_selected_db)


func modify_selected(id: String, value: float) -> void:
	if _selected_db != null and _selected_item != null:
		if _selected_value == id:
			_selected_item.set_value(id, value)
		else:
			_selected_item.add_value(id, value)
			_selected_item.remove_value(_selected_value)
		
		Datalogue.update_database(_selected_db)


func copy_selected(id: String, value: float) -> void:
	if _selected_db != null and _selected_item != null:
		_selected_item.add_value(id, value)
		Datalogue.update_database(_selected_db)


func delete_selected() -> void:
	if _selected_db != null and _selected_item != null and not _selected_value.is_empty():
		_selected_item.remove_value(_selected_value)
		Datalogue.update_database(_selected_db)


func _display_values() -> void:
	if _value_list == null:
		return

	_value_list.clear()
	_dup_btn.disabled = true
	_delete_btn.disabled = true

	var values := _selected_item.values()
	for id in values:
		var value := values[id] as float
		_value_list.add_item("%s: %f" % [id, value])
		_value_list.set_item_metadata(_value_list.get_item_count()-1, id)


func _on_database_selected(db: DlDatabase) -> void:
	_selected_db = db
	clear()


func _on_item_selected(item: DlItem) -> void:
	if _selected_item != item:
		if _selected_item != null:
			_selected_item.disconnect("changed", Callable(self, "_on_item_changed"))
		
		_selected_item = item
		_add_btn.disabled = false
		_selected_item.connect("changed", Callable(self, "_on_item_changed"))
		_display_values()


func _on_item_changed():
	_display_values()


func _on_AddValueBtn_pressed() -> void:
	emit_signal("request_value_form", DlEnums.FORM_MODE_NEW, "", 0)


func _on_DupValueBtn_pressed() -> void:
	var value := _selected_item.get_value(_selected_value)
	emit_signal("request_value_form", DlEnums.FORM_MODE_COPY, _selected_value, value)


func _on_RemoveValueBtn_pressed() -> void:
	emit_signal("request_remove_form", DlEnums.OBJECT_MODE_VALUE)


func _on_ValueList_item_selected(index: int) -> void:
	_selected_value = _value_list.get_item_metadata(index)
	_dup_btn.disabled = false
	_delete_btn.disabled = false


func _on_ValueList_item_activated(index: int) -> void:
	var id := _value_list.get_item_metadata(index) as String
	var value := _selected_item.get_value(id)
	
	emit_signal("request_value_form", DlEnums.FORM_MODE_MODIFY, id, value)
