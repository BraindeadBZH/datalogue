@tool
class_name DlContains
extends DlAbstractStatement

var id := ""
var contained := ""

func _init(text_id: String, contained_value: String) -> void:
	id = text_id
	contained = contained_value


func _eval(item: DlItem) -> bool:
	if item.has_text(id):
		return item.get_text(id).to_lower().find(contained) != -1
	
	return false
