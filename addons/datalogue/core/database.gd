@tool
class_name DatalogueDb
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


func add_item(item: DatalogueItem) -> void:
	_items[item.id()] = item
	emit_signal("changed")


func item_exists(id: String) -> bool:
	return _items.has(id)


func get_item(id: String) -> DatalogueItem:
	if _items.has(id):
		return _items[id]
	else:
		return null


func remove_item(id: String) -> void:
	_items.erase(id)
	emit_signal("changed")
