@tool
class_name DlDatabase
extends RefCounted


signal changed()


var _id := ""
var _items := {}
var _statistics := {}


func _init(id: String):
	_id = id
	_init_stats()


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


func statistics() -> Dictionary:
	return _statistics


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
	_update_stats()
	emit_signal("changed")


func copy_item(origin: DlItem, new_id: String) -> void:
	var item := origin.duplicate(new_id)
	_items[new_id] = item
	_update_stats()
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
	_update_stats()
	emit_signal("changed")

	if not old_id.is_empty():
		remove_item(old_id)


func remove_item(id: String) -> void:
	_items.erase(id)
	_update_stats()
	emit_signal("changed")


func _init_stats() -> void:
	_statistics.clear()

	_statistics = {
		"items": count(),
		# <class id> -> <items with class>
		"classes": {},
		# <class id> -> <class value> -> <items with class value>
		"classes_values": {},
		# <value id> -> <items with value>
		"values": {},
		# <value id> -> <minimum>
		"values_min": {},
		# <value id> -> <maximum>
		"values_max": {},
		# <text id> -> <items with text>
		"texts": {}
	}


func _update_stats() -> void:
	_init_stats()

	for id in _items:
		var item := _items[id] as DlItem
		for classif_id in item.classifications():
			if _statistics["classes"].has(classif_id):
				_statistics["classes"][classif_id] += 1
			else:
				_statistics["classes"][classif_id] = 1
				_statistics["classes_values"][classif_id] = {}

			var classif := item.get_classification(classif_id)
			for val_id in classif:
				if _statistics["classes_values"][classif_id].has(val_id):
					_statistics["classes_values"][classif_id][val_id] += 1
				else:
					_statistics["classes_values"][classif_id][val_id] = 1

		for val_id in item.values():
			var val := item.get_value(val_id)
			if _statistics["values"].has(val_id):
				_statistics["values"][val_id] += 1
				if val < _statistics["values_min"][val_id]:
					_statistics["values_min"][val_id] = val
				if val > _statistics["values_max"][val_id]:
					_statistics["values_max"][val_id] = val
			else:
				_statistics["values"][val_id] = 1
				_statistics["values_min"][val_id] = val
				_statistics["values_max"][val_id] = val

		for txt_id in item.texts():
			if _statistics["texts"].has(txt_id):
				_statistics["texts"][txt_id] += 1
			else:
				_statistics["texts"][txt_id] = 1
