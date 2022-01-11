@tool
class_name DlQuery
extends RefCounted


var _stmts := [[]]
var _or_index := 0


func clear() -> DlQuery:
	_stmts.clear()
	_or_index = 0
	_stmts.append([])
	return self


func from(classif_id: String, queried_value: String) -> DlQuery:
	_stmts[_or_index].append(DlFrom.new(classif_id, queried_value))
	return self


func where(value_id: String, operator: String, right_operand: float) -> DlQuery:
	_stmts[_or_index].append(DlWhere.new(value_id, DlUtils.string_to_operator(operator), right_operand))
	return self


func contains(text_id: String, contained_value: String) -> DlQuery:
	_stmts[_or_index].append(DlContains.new(text_id, contained_value))
	return self


func or_begin() -> DlQuery:
	_or_index += 1
	_stmts.append([])
	return self


func or_end() -> DlQuery:
	if _or_index > 0:
		_or_index -= 1
	return self


func execute(db: DlDatabase) -> Array:
	var result := Array()

	for id in db.items():
		if match_item(db.get_item(id)):
			result.append(id)

	return result


func match_item(item: DlItem) -> bool:
	var result := false

	for or_stmt in _stmts:
		var and_result := true
		for and_stmt in or_stmt:
			and_result = and_result and and_stmt._eval(item)

		result = result or and_result

	return result
