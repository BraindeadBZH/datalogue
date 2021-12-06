@tool
class_name DlDatabase
extends RefCounted


signal changed()


var _id := ""
var _items: Dictionary = {}


func _init(id: String):
	_id = id


func id() -> String:
	return _id


func set_id(new_id: String) -> void:
	_id = new_id
	emit_signal("changed")


func count() -> int:
	return _items.size()


func items() -> Dictionary:
	return _items


func add_item(item: DlItem) -> void:
	_items[item.id()] = item
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
