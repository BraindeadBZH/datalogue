@tool
extends Control


signal request_close()
signal submitted(filters: Dictionary)


@onready var _classif_tree := $MainLayout/ClassifLayout/ClassifTree
@onready var _value_id := $MainLayout/ValueLayout/ValueId
@onready var _value_op := $MainLayout/ValueLayout/ValueOp
@onready var _value_val := $MainLayout/ValueLayout/ValueVal
@onready var _text_id := $MainLayout/TextLayout/TextId
@onready var _text_val := $MainLayout/TextLayout/TextValue


var _db_stats := {}
var _saved_filters := {}


func clear() -> void:
	_classif_tree.clear()
	_value_id.clear()
	_value_op.clear()
	_value_val.value = 0
	_text_id.clear()
	_text_val.text = ""
	_db_stats = {}
	_saved_filters = {}


func set_filtered_database(db: DlDatabase) -> void:
	clear()
	_db_stats = db.statistics()
	_update_ui()


func _update_ui() -> void:
	var tree_root := _classif_tree.create_item() as TreeItem
	tree_root.set_text(0, "All (%d items)" % _db_stats["items"])
	tree_root.select(0)
	for id in _db_stats["classes"]:
		var item := _classif_tree.create_item(tree_root) as TreeItem
		item.set_text(0, "%s (%d items)" % [id, _db_stats["classes"][id]])
		item.set_metadata(0, id)
		item.set_selectable(0, false)
		item.collapsed = true
		
		for val in _db_stats["classes_values"][id]:
			var child := _classif_tree.create_item(item) as TreeItem
			child.set_text(0, "%s (%d items)" % [val, _db_stats["classes_values"][id][val]])
			child.set_metadata(0, val)
	
	_value_id.add_item("None")
	_value_id.set_item_metadata(0, "none")
	for id in _db_stats["values"]:
		_value_id.add_item("%s (%d items)" % [id, _db_stats["values"][id]])
		_value_id.set_item_metadata(_value_id.get_item_count()-1, id)
	
	_value_op.add_item("=")
	_value_op.set_item_id(0, OP_EQUAL)
	_value_op.add_item("<")
	_value_op.set_item_id(1, OP_LESS)
	_value_op.add_item(">")
	_value_op.set_item_id(2, OP_GREATER)
	_value_op.add_item("<=")
	_value_op.set_item_id(3, OP_LESS_EQUAL)
	_value_op.add_item(">=")
	_value_op.set_item_id(4, OP_GREATER_EQUAL)
	
	_text_id.add_item("None")
	_text_id.set_item_metadata(0, "none")
	for id in _db_stats["texts"]:
		_text_id.add_item("%s (%d items)" % [id, _db_stats["texts"][id]])
		_text_id.set_item_metadata(_text_id.get_item_count()-1, id)


func _update_saved_filters() -> void:
	_saved_filters.clear()
	
	if not _classif_tree.get_root().is_selected(0):
		_saved_filters["classif"] = []
		var classif := _classif_tree.get_next_selected(_classif_tree.get_root()) as TreeItem
		while classif != null:
			var parent := classif.get_parent()
			var pair := {}
			
			pair[parent.get_metadata(0)] = classif.get_metadata(0)
			_saved_filters["classif"].append(pair)
			
			classif = _classif_tree.get_next_selected(classif)
	
	if not _value_id.selected == 0:
		_saved_filters["value"] = {}
		_saved_filters["value"]["id"] = _value_id.get_selected_metadata()
		_saved_filters["value"]["op"] = _value_op.get_selected_id()
		_saved_filters["value"]["val"] = _value_val.value
	
	if not _text_id.selected == 0 and not _text_val.text.is_empty():
		_saved_filters["text"] = {}
		_saved_filters["text"]["id"] = _text_id.get_selected_metadata()
		_saved_filters["text"]["contains"] = _text_val.text


func _submit() -> void:
	_update_saved_filters()
	emit_signal("submitted", _saved_filters)


func _on_CancelBtn_pressed() -> void:
	emit_signal("request_close")


func _on_ClearBtn_pressed() -> void:
	_classif_tree.get_root().call_recursive("deselect", 0)
	_classif_tree.get_root().select(0)
	_value_id.select(0)
	_value_op.select(0)
	_value_val.value = 0
	_text_id.select(0)
	_text_val.text = ""
	
	_submit()


func _on_ApplyBtn_pressed() -> void:
	_submit()
