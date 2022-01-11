@tool
class_name DlWhere
extends DlAbstractStatement

var id := ""
var op := OP_EQUAL
var value := 0.0

func _init(value_id: String, query_op: int, query_value: float) -> void:
	id = value_id
	op = query_op
	value = query_value

func _eval(item: DlItem) -> bool:
	if item.has_value(id):
		var item_val := item.get_value(id)

		match op:
			OP_EQUAL:
				return item_val == value
			OP_LESS_EQUAL:
				return item_val <= value
			OP_LESS:
				return item_val < value
			OP_GREATER_EQUAL:
				return item_val >= value
			OP_GREATER:
				return item_val > value
	
	return false
