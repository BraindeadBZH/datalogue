@tool
class_name DatalogueItem
extends RefCounted


signal changed()


var _id := ""
var _classif := {}
var _values := {}
var _texts := {}


func _init(id: String):
	_id = id


func id() -> String:
	return _id


func duplicate() -> DatalogueItem:
	var copy = get_script().new(id)
	copy._classif  = _classif.duplicate()
	copy._values = _values.duplicate()
	copy._texts  = _texts.duplicate()
	return copy


func classifications() -> Dictionary:
	return _classif


func set_classifications(classifications: Dictionary) -> void:
	_classif = classifications
	mark_changed()


func add_classification(id: String, values: Array[String]) -> void:
	_classif[id] = values
	mark_changed()


func set_classification(id: String, values: Array[String]) -> void:
	_classif[id] = values
	mark_changed()


func has_classification(id: String) -> bool:
	return _classif.has(id)


func match_classification(id: String, value: String) -> bool:
	if _classif.has(id):
		var values := _classif[id] as Array[String]
		if values.has(value):
			return true
	return false


func get_classification(id: String) -> Array[String]:
	if _classif.has(id):
		return _classif[id]
	else:
		return []


func remove_category(id: String) -> void:
	_classif.erase(id)
	mark_changed()


func values() -> Dictionary:
	return _values


func set_values(values: Dictionary) -> void:
	_values = values
	mark_changed()


func add_value(id: String, value: int) -> void:
	_values[id] = value
	mark_changed()


func set_value(id: String, value: int) -> void:
	_values[id] = value
	mark_changed()


func has_value(id: String) -> bool:
	return _values.has(id)


func get_value(id: String) -> int:
	return _values[id]


func remove_value(id: String) -> void:
	_values.erase(id)
	mark_changed()


func texts() -> Dictionary:
	return _texts


func set_texts(texts: Dictionary) -> void:
	_texts = texts
	mark_changed()


func add_text(id: String, text: String) -> void:
	_texts[id] = text
	mark_changed()


func set_text(id: String, text: String) -> void:
	_texts[id] = text
	mark_changed()


func has_text(id: String) -> bool:
	return _texts.has(id)


func get_text(id: String) -> String:
	return _texts[id]


func remove_text(id: String) -> void:
	_texts.erase(id)
	mark_changed()


func mark_changed():
	emit_signal("changed")