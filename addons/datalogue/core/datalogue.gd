@tool
extends Node


signal changed()


const FMT_FILE_PATH := "%s/%s"
const FMT_DB_PATH := "%s/%s.data"


var _folder := ""
var _databases := {}


func _enter_tree():
	_load_databases()


func _exit_tree():
	_clean()


func validate_db_id(id: String) -> String:
	if id.is_empty():
		return "Invalid database ID: empty"
	
	if _databases.has(id):
		return "Invalid database ID: not unique"
	
	if not Utils.is_id_valid(id):
		return "Invalid database ID: invalid format"
	
	return ""


func create_db(id: String) -> void:
	print("Create database %s" % id)


func _load_databases() -> void:
	pass


func _clean() -> void:
	_databases = {}
