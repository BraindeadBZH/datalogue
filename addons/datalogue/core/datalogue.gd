@tool
extends Node


signal database_added()
signal database_updated(db: DatalogueDb)
signal database_removed()


const FOLDER_PATH := "res://_datalogue"
const FMT_FILE_PATH := "%s/%s"
const FMT_DB_PATH := "%s/%s.data"


var _databases := {}


func _enter_tree():
	_load_databases()


func _exit_tree():
	_clean()


func validate_id(id: String) -> String:
	if id.is_empty():
		return "ID cannot be empty"
	
	if _databases.has(id):
		return "ID must be unique"
	
	if not DatalogueUtils.is_id_valid(id):
		return "ID cannot contains space or special characters"
	
	return ""


func databases() -> Dictionary:
	return _databases;


func create_database(db: DatalogueDb) -> void:
	_databases[db.id()] = db
	_write_database(db)
	emit_signal("database_added")


func get_database(id: String) -> DatalogueDb:
	if _databases.has(id):
		return _databases[id]
	else:
		return null


func update_database(modified_db: DatalogueDb) -> void:
	_databases[modified_db.id()] = modified_db
	_write_database(modified_db)
	emit_signal("database_updated", modified_db)


func delete_database(id: String):
	if !_databases.has(id): return

	var db: DatalogueDb = _databases[id]
	_databases.erase(id)

	var dir := Directory.new()
	if dir.open(FOLDER_PATH) == OK:
		dir.remove(FMT_DB_PATH % [FOLDER_PATH, db.id()])

	emit_signal("database_removed")


func _load_databases() -> void:
	var dir := Directory.new()
	if dir.open(FOLDER_PATH) == OK:
		dir.list_dir_begin(true, true)
		var filename := dir.get_next()
		while filename != "":
			if DatalogueUtils.is_db_file(filename):
				var db := _read_database(filename)
				_databases[db.id()] = db
			filename = dir.get_next()
		dir.list_dir_end()
		emit_signal("database_added")


func _write_database(db: DatalogueDb):
	var file := ConfigFile.new()

	file.set_value("meta", "id", db.id())

	for id in db.items():
		var item := db.get_item(id)
		file.set_value("items", item.id(), {
			"classifications": item.classifications(),
			"values": item.values(),
			"texts": item.texts()
			})

	var err := file.save(FMT_DB_PATH % [FOLDER_PATH, db.id()])
	if err != OK:
		printerr("Error while writing database: %s" % error_string(err))
		return


func _read_database(filename: String) -> DatalogueDb:
	var path := FMT_FILE_PATH % [FOLDER_PATH, filename]
	var file := ConfigFile.new()

	var err := file.load(path)
	if err != OK:
		printerr("Error while loading database")
		return null

	var db := DatalogueDb.new(file.get_value("meta", "id", "noid"))

	if file.has_section("items"):
		for entry in file.get_section_keys("items"):
			var item := DatalogueItem.new(entry)
			var data = file.get_value("items", entry)
			item.set_classifications(data["classifications"])
			item.set_values(data["values"])
			item.set_texts(data["texts"])
			db.add_item(item)

	return db


func _clean() -> void:
	_databases = {}
