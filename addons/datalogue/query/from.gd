@tool
class_name DlFrom
extends DlAbstractStatement

var id := ""
var query := ""

func _init(class_id: String, class_query: String) -> void:
	id = class_id
	query = class_query


func _eval(item: DlItem) -> bool:
	if item.has_classification(id):
		var values := item.get_classification(id)
		for value in values:
			if value.match(query):
				return true
	return false
