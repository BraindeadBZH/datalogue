@tool
class_name DlUtils
extends RefCounted


static func is_id_valid(id: String) -> bool:
	return is_valid_for_regex(id, "^[a-zA-Z]+([a-zA-Z0-9]|_)*$")


static func is_db_file(filename: String) -> bool:
	return is_valid_for_regex(filename, "^[a-zA-Z]+([a-zA-Z0-9]|_)*\\.data$")


static func is_valid_for_regex(value: String, regex: String) -> bool:
	var validation := RegEx.new()
	validation.compile(regex)
	if validation.search(value) != null:
		return true
	else:
		return false
