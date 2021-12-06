@tool
extends VBoxContainer


signal request_create_form(mode: int)
signal request_rename_form(mode: int, id: String)
signal request_remove_form(mode: int)


@onready var _items_list: ItemList = $ItemsList
@onready var _add_btn: Button = $ItemsTools/AddItemBtn
@onready var _dup_btn: Button = $ItemsTools/DupItemBtn
@onready var _delete_btn: Button = $ItemsTools/RemoveItemBtn


var _selected_db: DlDatabase = null
var _selected_item: DlItem = null


func clear() -> void:
	if _selected_db != null:
		_selected_db.disconnect("changed", Callable(self, "_on_database_changed"))
		_selected_db = null
	
	_items_list.clear()
	
	_add_btn.disabled = true
	_dup_btn.disabled = true
	_delete_btn.disabled = true


func create_item(id: String) -> void:
	if _selected_db != null:
		_selected_db.add_item(DlItem.new(id))
		Datalogue.update_database(_selected_db)


func rename_selected_item(new_id: String, old_id: String):
	_selected_item.set_id(new_id)
	_selected_db.update_item(_selected_item, old_id)
	Datalogue.update_database(_selected_db)


func selected_id() -> String:
	if _selected_item == null:
		return ""
	else:
		return _selected_item.id()


func delete_selected() -> void:
	if _selected_db != null:
		_selected_db.remove_item(_selected_item.id())
		Datalogue.update_database(_selected_db)


func _display_items() -> void:
	if _items_list == null:
		return

	_items_list.clear()
	_selected_item = null
	_dup_btn.disabled = true
	_delete_btn.disabled = true

	var items := _selected_db.items()
	for id in items:
		var item: DlItem = items[id]
		_items_list.add_item("%s" % item.id())
		_items_list.set_item_metadata(_items_list.get_item_count()-1, item.id())


func _on_database_selected(db: DlDatabase) -> void:
	if _selected_db != db:
		if _selected_db != null:
			_selected_db.disconnect("changed", Callable(self, "_on_database_changed"))
		
		_selected_db = db
		_add_btn.disabled = false
		_selected_db.connect("changed", Callable(self, "_on_database_changed"))
		_display_items()


func _on_database_changed() -> void:
	_display_items()


func _on_ItemsList_item_selected(index: int) -> void:
	_selected_item = _selected_db.get_item(_items_list.get_item_metadata(index))
	_dup_btn.disabled = false
	_delete_btn.disabled = false


func _on_ItemsList_item_activated(index: int) -> void:
	emit_signal("request_rename_form", DlEnums.OBJECT_MODE_ITEM, _selected_item.id())


func _on_AddItemBtn_pressed() -> void:
	emit_signal("request_create_form", DlEnums.OBJECT_MODE_ITEM)


func _on_RemoveItemBtn_pressed() -> void:
	emit_signal("request_remove_form", DlEnums.OBJECT_MODE_ITEM)
