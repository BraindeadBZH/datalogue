@tool
class_name DlDatabase
extends RefCounted


signal changed()


var _id := ""
var _items := {}


func _init(id: String):
	_id = id


func id() -> String:
	return _id


func set_id(new_id: String) -> void:
	_id = new_id
	emit_signal("changed")


func duplicate(new_id: String = "") -> DlDatabase:
	if new_id.is_empty():
		new_id = _id
	
	var copy := get_script().new(new_id) as DlDatabase
	for item_id in _items:
		var item := _items[item_id] as DlItem
		copy.add_item(item.duplicate())
	return copy


func count() -> int:
	return _items.size()


func items() -> Dictionary:
	return _items


func validate_item_id(id: String) -> String:
	if id.is_empty():
		return "ID cannot be empty"
	
	if _items.has(id):
		return "ID must be unique"
	
	if not DlUtils.is_id_valid(id):
		return "ID can only contains letters, numbers or _"
	
	return ""


func add_item(item: DlItem) -> void:
	_items[item.id()] = item
	emit_signal("changed")


func copy_item(origin: DlItem, new_id: String) -> void:
	var item := origin.duplicate(new_id)
	_items[new_id] = item
	emit_signal("changed")


func item_exists(id: String) -> bool:
	return _items.has(id)


func get_item(id: String) -> DlItem:
	if _items.has(id):
		return _items[id]
	else:
		return null


func update_item(modified_item: DlItem, old_id: String = "") -> void:
	_items[modified_item.id()] = modified_item
	emit_signal("changed")
	
	if not old_id.is_empty():
		remove_item(old_id)


func remove_item(id: String) -> void:
	_items.erase(id)
	emit_signal("changed")
