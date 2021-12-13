@tool
extends VBoxContainer


signal request_create_form(mode: int)
signal request_rename_form(mode: int, id: String)
signal request_copy_form(mode: int, id: String)
signal request_remove_form(mode: int)
signal database_selected(db: DlDatabase)


@onready var _db_list := $DatabasesList
@onready var _dup_btn := $DatabasesTools/DupDatabaseBtn
@onready var _delete_btn := $DatabasesTools/RemoveDatabaseBtn


var _selected_db: DlDatabase = null


func _ready() -> void:
	Datalogue.connect("database_added", Callable(self, "_on_database_added"))
	Datalogue.connect("database_updated", Callable(self, "_on_database_updated"))
	Datalogue.connect("database_removed", Callable(self, "_on_database_removed"))
	_display_databases()


func selected_id() -> String:
	if _selected_db == null:
		return ""
	else:
		return _selected_db.id()


func create_database(id: String) -> void:
	Datalogue.create_database(DlDatabase.new(id))


func copy_selected_database(id: String) -> void:
	Datalogue.copy_database(_selected_db, id)


func rename_selected_database(id: String, origin: String) -> void:
	_selected_db.set_id(id)
	Datalogue.update_database(_selected_db, origin)


func delete_selected() -> void:
	if _selected_db != null:
		Datalogue.delete_database(_selected_db.id())


func _display_databases() -> void:
	if _db_list == null:
		return

	_db_list.clear()
	_selected_db = null
	_dup_btn.disabled = true
	_delete_btn.disabled = true

	var databases := Datalogue.databases()
	for id in databases:
		var db := databases[id] as DlDatabase
		_db_list.add_item("%s (%d items)" % [db.id(), db.count()])
		_db_list.set_item_metadata(_db_list.get_item_count()-1, db.id())


func _on_database_added() -> void:
	_display_databases()


func _on_database_updated(db: DlDatabase) -> void:
	for idx in range(_db_list.item_count):
		if db.id() == _db_list.get_item_metadata(idx):
			_db_list.set_item_text(idx, "%s (%d items)" % [db.id(), db.count()])


func _on_database_removed() -> void:
	_display_databases()


func _on_DatabasesList_item_selected(index: int) -> void:
	_selected_db = Datalogue.get_database(_db_list.get_item_metadata(index))
	_dup_btn.disabled = false
	_delete_btn.disabled = false
	emit_signal("database_selected", _selected_db)


func _on_DatabasesList_item_activated(index: int) -> void:
	emit_signal("request_rename_form", DlEnums.OBJECT_MODE_DB, _selected_db.id())


func _on_AddDatabaseBtn_pressed() -> void:
	emit_signal("request_create_form", DlEnums.OBJECT_MODE_DB)


func _on_RemoveDatabaseBtn_pressed() -> void:
	emit_signal("request_remove_form", DlEnums.OBJECT_MODE_DB)


func _on_DupDatabaseBtn_pressed() -> void:
	emit_signal("request_copy_form", DlEnums.OBJECT_MODE_DB, _selected_db.id())
