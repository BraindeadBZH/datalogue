@tool
extends VBoxContainer


signal request_create_form(mode)


@onready var _db_list: ItemList = $DatabasesList
@onready var _dup_btn: Button = $DatabasesTools/DupDatabaseBtn
@onready var _delete_btn: Button = $DatabasesTools/RemoveDatabaseBtn


func _ready() -> void:
	Datalogue.connect("changed", Callable(self, "_on_Databases_changed"))
	_display_databases()


func _display_databases() -> void:
	if _db_list == null:
		return

	_db_list.clear()
	_dup_btn.disabled = true
	_delete_btn.disabled = true

	var databases := Datalogue.databases()
	for id in databases:
		var db: DatalogueDb = databases[id]
		_db_list.add_item("%s (%d items)" % [db.id(), db.count()])
		_db_list.set_item_metadata(_db_list.get_item_count()-1, db.id)


func _on_Databases_changed() -> void:
	_display_databases()


func _on_AddDatabaseBtn_pressed() -> void:
	emit_signal("request_create_form", DatalogueUi.CREATE_MODE_DB)
