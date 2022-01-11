@tool
extends VBoxContainer


signal request_create_form(mode: int)
signal request_rename_form(mode: int, id: String)
signal request_copy_form(mode: int, id: String)
signal request_remove_form(mode: int)
signal request_filter_form()
signal item_selected(item: DlItem)


@onready var _items_list := $ItemsList
@onready var _add_btn := $ItemsTools/AddItemBtn
@onready var _dup_btn := $ItemsTools/DupItemBtn
@onready var _delete_btn := $ItemsTools/RemoveItemBtn
@onready var _filter_btn := $Title/ItemFilterBtn


var _selected_db: DlDatabase = null
var _selected_item: DlItem = null
var _filter_query: DlQuery = null


func clear() -> void:
	if _selected_db != null:
		_selected_db.disconnect("changed", Callable(self, "_on_database_changed"))
		_selected_db = null
	
	_items_list.clear()
	
	_add_btn.disabled = true
	_dup_btn.disabled = true
	_delete_btn.disabled = true
	_filter_btn.disabled = true


func selected_id() -> String:
	if _selected_item == null:
		return ""
	else:
		return _selected_item.id()


func create_item(id: String) -> void:
	if _selected_db != null:
		_selected_db.add_item(DlItem.new(id))
		Datalogue.update_database(_selected_db)


func validate_id(id: String) -> String:
	if _selected_db != null:
		return _selected_db.validate_item_id(id)
	else:
		return ""


func validate_classification(id: String, values: Array[String], mode: int, origin: String) -> String:
	if _selected_item != null:
		return _selected_item.validate_classification(id, values, mode, origin)
	else:
		return ""


func validate_value(id: String, mode: int, origin: String) -> String:
	if _selected_item != null:
		return _selected_item.validate_value(id, mode, origin)
	else:
		return ""


func validate_text(id: String, mode: int, origin: String) -> String:
	if _selected_item != null:
		return _selected_item.validate_text(id, mode, origin)
	else:
		return ""


func copy_selected_item(id: String):
	if _selected_db != null:
		_selected_db.copy_item(_selected_item, id)
		Datalogue.update_database(_selected_db)


func rename_selected_item(id: String, origin: String):
	_selected_item.set_id(id)
	_selected_db.update_item(_selected_item, origin)
	Datalogue.update_database(_selected_db)


func delete_selected() -> void:
	if _selected_db != null:
		_selected_db.remove_item(_selected_item.id())
		Datalogue.update_database(_selected_db)


func set_filters(filters: Dictionary) -> void:
	_filter_query = null
	
	if not filters.is_empty():
		_filter_query = DlQuery.new()
		
		if filters.has("classif"):
			var statement := ""
			
			for pair in filters["classif"]:
				for id in pair:
					var val := pair[id] as String
					_filter_query.from(id, val)
					statement += "%s:%s," % [id, val]
		
		if filters.has("value"):
			var id := filters["value"]["id"] as String
			var op := DlUtils.operator_to_string(filters["value"]["op"])
			var val := filters["value"]["val"] as float
			
			_filter_query.where(id, op, val)
		
		if filters.has("text"):
			var id := filters["text"]["id"] as String
			var contains := filters["text"]["contains"] as String
			
			_filter_query.contains(id, contains)
		
	_display_items()


func _display_items() -> void:
	if _items_list == null:
		return

	_items_list.clear()
	_selected_item = null
	_dup_btn.disabled = true
	_delete_btn.disabled = true

	var items := _selected_db.items()
	var filtered := []
	
	if _filter_query != null:
		filtered = _filter_query.execute(_selected_db)
	
	for id in items:
		if _filter_query != null:
			if not filtered.has(id):
				continue
		
		var item := items[id] as DlItem
		_items_list.add_item("%s" % item.id())
		_items_list.set_item_metadata(_items_list.get_item_count()-1, item.id())


func _on_database_selected(db: DlDatabase) -> void:
	if _selected_db != db:
		if _selected_db != null:
			_selected_db.disconnect("changed", Callable(self, "_on_database_changed"))
		
		_selected_db = db
		_add_btn.disabled = false
		_filter_btn.disabled = false
		_filter_query = null
		_selected_db.connect("changed", Callable(self, "_on_database_changed"))
		_display_items()


func _on_database_changed() -> void:
	_display_items()


func _on_ItemsList_item_selected(index: int) -> void:
	_selected_item = _selected_db.get_item(_items_list.get_item_metadata(index))
	_dup_btn.disabled = false
	_delete_btn.disabled = false
	emit_signal("item_selected", _selected_item)


func _on_ItemsList_item_activated(index: int) -> void:
	emit_signal("request_rename_form", DlEnums.OBJECT_MODE_ITEM, _selected_item.id())


func _on_AddItemBtn_pressed() -> void:
	emit_signal("request_create_form", DlEnums.OBJECT_MODE_ITEM)


func _on_RemoveItemBtn_pressed() -> void:
	emit_signal("request_remove_form", DlEnums.OBJECT_MODE_ITEM)


func _on_DupItemBtn_pressed() -> void:
	emit_signal("request_copy_form", DlEnums.OBJECT_MODE_ITEM, _selected_item.id())


func _on_ItemFilterBtn_pressed() -> void:
	emit_signal("request_filter_form")
