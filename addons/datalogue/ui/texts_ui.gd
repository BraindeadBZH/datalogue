@tool
extends HBoxContainer


signal request_text_form(mode: int, origin: String, text: String)
signal request_remove_form(mode: int)


@onready var _text_list := $TextsList
@onready var _add_btn := $TextsTools/AddTextBtn
@onready var _dup_btn := $TextsTools/DupTextBtn
@onready var _delete_btn := $TextsTools/RemoveTextBtn


var _selected_db: DlDatabase = null
var _selected_item: DlItem = null
var _selected_text := ""


func clear() -> void:
	if _selected_item != null:
		_selected_item.disconnect("changed", Callable(self, "_on_item_changed"))
		_selected_item = null
	
	_text_list.clear()
	_selected_text = ""
	
	_add_btn.disabled = true
	_dup_btn.disabled = true
	_delete_btn.disabled = true


func selected_id() -> String:
	return _selected_text


func create_text(id: String, text: String) -> void:
	if _selected_db != null and _selected_item != null:
		_selected_item.add_text(id, text)
		Datalogue.update_database(_selected_db)


func modify_selected(id: String, text: String) -> void:
	if _selected_db != null and _selected_item != null:
		if _selected_text == id:
			_selected_item.set_text(id, text)
		else:
			_selected_item.add_text(id, text)
			_selected_item.remove_text(_selected_text)
		
		Datalogue.update_database(_selected_db)


func copy_selected(id: String, text: String) -> void:
	if _selected_db != null and _selected_item != null:
		_selected_item.add_text(id, text)
		Datalogue.update_database(_selected_db)


func delete_selected() -> void:
	if _selected_db != null and _selected_item != null and not _selected_text.is_empty():
		_selected_item.remove_text(_selected_text)
		Datalogue.update_database(_selected_db)


func _display_texts() -> void:
	if _text_list == null:
		return

	_text_list.clear()
	_dup_btn.disabled = true
	_delete_btn.disabled = true

	var texts := _selected_item.texts()
	for id in texts:
		var text := texts[id] as String
		var lines := text.split("\n")
		if lines.size() > 1:
			_text_list.add_item("%s: %s (...)" % [id, lines[0]])
		else:
			_text_list.add_item("%s: %s" % [id, text])
		_text_list.set_item_metadata(_text_list.get_item_count()-1, id)


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
		_display_texts()


func _on_item_changed():
	_display_texts()


func _on_AddTextBtn_pressed() -> void:
	emit_signal("request_text_form", DlEnums.FORM_MODE_NEW, "", "")


func _on_DupTextBtn_pressed() -> void:
	var text := _selected_item.get_text(_selected_text)
	emit_signal("request_text_form", DlEnums.FORM_MODE_COPY, _selected_text, text)


func _on_RemoveTextBtn_pressed() -> void:
	emit_signal("request_remove_form", DlEnums.OBJECT_MODE_TEXT)


func _on_TextsList_item_selected(index: int) -> void:
	_selected_text = _text_list.get_item_metadata(index)
	_dup_btn.disabled = false
	_delete_btn.disabled = false


func _on_TextsList_item_activated(index: int) -> void:
	var id := _text_list.get_item_metadata(index) as String
	var text := _selected_item.get_text(id)
	
	emit_signal("request_text_form", DlEnums.FORM_MODE_MODIFY, id, text)
