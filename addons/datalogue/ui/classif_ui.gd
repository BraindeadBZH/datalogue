@tool
extends HBoxContainer


signal request_classif_form(mode: int)


@onready var _classif_list: ItemList = $ClassifList
@onready var _add_btn: Button = $ClassifTools/AddClassifBtn
@onready var _dup_btn: Button = $ClassifTools/DupClassifBtn
@onready var _delete_btn: Button = $ClassifTools/RemoveClassifBtn


var _selected_db: DlDatabase = null
var _selected_item: DlItem = null


func clear() -> void:
	if _selected_item != null:
		_selected_item.disconnect("changed", Callable(self, "_on_item_changed"))
		_selected_item = null
	
	_classif_list.clear()
	
	_add_btn.disabled = true
	_dup_btn.disabled = true
	_delete_btn.disabled = true


func create_classif(id: String, values: Array[String]) -> void:
	if _selected_db != null and _selected_item != null:
		_selected_item.add_classification(id, values)
		Datalogue.update_database(_selected_db)


func _display_classifs() -> void:
	if _classif_list == null:
		return

	_classif_list.clear()
	_dup_btn.disabled = true
	_delete_btn.disabled = true

	var classifs := _selected_item.classifications()
	for id in classifs:
		var classif: Array[String] = classifs[id]
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
	emit_signal("request_classif_form", DlEnums.CREATE_MODE_NEW)
