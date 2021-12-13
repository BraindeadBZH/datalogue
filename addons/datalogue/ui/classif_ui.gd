@tool
extends HBoxContainer


signal request_classif_form(mode: int, origin: String, values: Array)
signal request_remove_form(mode: int)


@onready var _classif_list := $ClassifList
@onready var _add_btn := $ClassifTools/AddClassifBtn
@onready var _dup_btn := $ClassifTools/DupClassifBtn
@onready var _delete_btn := $ClassifTools/RemoveClassifBtn


var _selected_db: DlDatabase = null
var _selected_item: DlItem = null
var _selected_classif := ""


func clear() -> void:
	if _selected_item != null:
		_selected_item.disconnect("changed", Callable(self, "_on_item_changed"))
		_selected_item = null
	
	_classif_list.clear()
	_selected_classif = ""
	
	_add_btn.disabled = true
	_dup_btn.disabled = true
	_delete_btn.disabled = true


func selected_id() -> String:
	return _selected_classif


func create_classif(id: String, values: Array[String]) -> void:
	if _selected_db != null and _selected_item != null:
		_selected_item.add_classification(id, values)
		Datalogue.update_database(_selected_db)


func modify_selected(id: String, values: Array[String]) -> void:
	if _selected_db != null and _selected_item != null:
		if _selected_classif == id:
			_selected_item.set_classification(id, values)
		else:
			_selected_item.add_classification(id, values)
			_selected_item.remove_classification(_selected_classif)
		
		Datalogue.update_database(_selected_db)


func copy_selected(id: String, values: Array[String]) -> void:
	if _selected_db != null and _selected_item != null:
		_selected_item.add_classification(id, values)
		Datalogue.update_database(_selected_db)


func delete_selected() -> void:
	if _selected_db != null and _selected_item != null and not _selected_classif.is_empty():
		_selected_item.remove_classification(_selected_classif)
		Datalogue.update_database(_selected_db)


func _display_classifs() -> void:
	if _classif_list == null:
		return

	_classif_list.clear()
	_dup_btn.disabled = true
	_delete_btn.disabled = true

	var classifs := _selected_item.classifications()
	for id in classifs:
		var classif := classifs[id] as Array[String]
		_classif_list.add_item("%s: %s" % [id, ", ".join(classif)])
		_classif_list.set_item_metadata(_classif_list.get_item_count()-1, id)


func _on_database_selected(db: DlDatabase) -> void:
	_selected_db = db
	clear()


func _on_item_selected(item: DlItem) -> void:
	if _selected_item != item:
		if _selected_item != null:
			_selected_item.disconnect("changed", Callable(self, "_on_item_changed"))
		
		_selected_item = item
		_add_btn.disabled = false
		_selected_item.connect("changed", Callable(self, "_on_item_changed"))
		_display_classifs()


func _on_item_changed():
	_display_classifs()


func _on_AddClassifBtn_pressed() -> void:
	emit_signal("request_classif_form", DlEnums.FORM_MODE_NEW, "", [])


func _on_DupClassifBtn_pressed() -> void:
	var values := _selected_item.get_classification(_selected_classif)
	emit_signal("request_classif_form", DlEnums.FORM_MODE_COPY, _selected_classif, values)


func _on_RemoveClassifBtn_pressed() -> void:
	emit_signal("request_remove_form", DlEnums.OBJECT_MODE_CLASSIF)


func _on_ClassifList_item_selected(index: int) -> void:
	_selected_classif = _classif_list.get_item_metadata(index)
	_dup_btn.disabled = false
	_delete_btn.disabled = false


func _on_ClassifList_item_activated(index: int) -> void:
	var id := _classif_list.get_item_metadata(index) as String
	var values := _selected_item.get_classification(id)
	
	emit_signal("request_classif_form", DlEnums.FORM_MODE_MODIFY, id, values)
