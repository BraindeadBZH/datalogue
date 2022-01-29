class_name DlInstance
extends RefCounted


var _origin_data: DlItem = null


func _init(item: DlItem) -> void:
	_origin_data = item


func ref() -> int:
	return get_instance_id()


func id() -> String:
	return _origin_data.id()


func get_classification(id: String) -> Array[String]:
	return _origin_data.get_classification(id)


func get_value(id: String) -> float:
	return _origin_data.get_value(id)


func get_text(id: String) -> String:
	return _origin_data.get_text(id)
