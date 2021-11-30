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


func test() -> void:
	print("This is working")


func _load_databases() -> void:
	pass


func _clean() -> void:
	_databases = {}
