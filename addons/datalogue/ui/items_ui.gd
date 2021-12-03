@tool
extends VBoxContainer


signal request_create_form(mode: int)
signal request_remove_form(mode: int)


@onready var _items_list: ItemList = $ItemsList
@onready var _add_btn: Button = $ItemsTools/AddItemBtn
@onready var _dup_btn: Button = $ItemsTools/DupItemBtn
@onready var _delete_btn: Button = $ItemsTools/RemoveItemBtn


var _selected_db: DatalogueDb = null
var _selected_item: DatalogueItem = null


func clear() -> void:
	if _selected_db != null:
		_selected_db.disconnect("changed", Callable(self, "_on_database_changed"))
		_selected_db = null
	
	_items_list.clear()
	
	_add_btn.disabled = true
	_dup_btn.disabled = true
	_delete_btn.disabled = true


func create_item(id: String) -> void:
	if _selected_db != null:
		_selected_db.add_item(DatalogueItem.new(id))
		Datalogue.update_database(_selected_db)


func _display_items() -> void:
	if _items_list == null:
		return

	_items_list.clear()
	_selected_item = null
	_dup_btn.disabled = true
	_delete_btn.disabled = true

	var items := _selected_db.items()
	for id in items:
		var item: DatalogueItem = items[id]
		_items_list.add_item("%s" % item.id())
		_items_list.set_item_metadata(_items_list.get_item_count()-1, item.id())


func _on_database_selected(db: DatalogueDb) -> void:
	if _selected_db != db:
		if _selected_db != null:
			_selected_db.disconnect("changed", Callable(self, "_on_database_changed"))
		
		_selected_db = db
		_add_btn.disabled = false
		_selected_db.connect("changed", Callable(self, "_on_database_changed"))
		_display_items()


func _on_database_changed() -> void:
	_display_items()


func _on_AddItemBtn_pressed() -> void:
	emit_signal("request_create_form", DatalogueUi.CREATE_MODE_ITEM)
