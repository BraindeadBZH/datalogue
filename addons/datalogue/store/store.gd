class_name DlStore
extends RefCounted


class ValueSorter:
	var _values := []
	var _asc := true

	func _init(values: Array, asc: bool) -> void:
		_values = values
		_asc = asc

	func sort(left: DlInstance, right: DlInstance) -> bool:
		return _recurive_sort(left.data(), right.data())


	func _recurive_sort(ldata: DlItem, rdata: DlItem, depth: int = 0) -> bool:
		if depth >= _values.size():
			return false

		var value_id = _values[depth]

		if ldata.get_value(value_id) == rdata.get_value(value_id):
			return _recurive_sort(ldata, rdata, depth+1)
		elif _asc and ldata.get_value(value_id) < rdata.get_value(value_id):
			return true
		elif not _asc and ldata.get_value(value_id) > rdata.get_value(value_id):
			return true

		return false


class TextSorter:
	var _texts := []
	var _asc := true

	func _init(texts: Array, asc: bool) -> void:
		_texts = texts
		_asc = asc

	func sort(left: DlInstance, right: DlInstance) -> bool:
		return _recurive_sort(left.data(), right.data())


	func _recurive_sort(ldata: DlItem, rdata: DlItem, depth: int = 0) -> bool:
		if depth >= _texts.size():
			return false

		var text_id = _texts[depth]

		if ldata.get_text(text_id).casecmp_to(rdata.get_text(text_id)) == 0:
			return _recurive_sort(ldata, rdata, depth+1)
		elif _asc and ldata.get_text(text_id).casecmp_to(rdata.get_text(text_id)) == -1:
			return true
		elif not _asc and ldata.get_text(text_id).casecmp_to(rdata.get_text(text_id)) == 1:
			return true

		return false


signal changed()
signal inserted(item: DlItem)
signal removed(item: DlItem)


var _rng := DlRng.new()
var _content: Array[DlInstance] = []
var _index := {}


static func instanciate(item: DlItem) -> DlInstance:
	var inst := DlInstance.new(item)
	return inst


static func instanciate_multi(item: DlItem, count: int) -> Array[DlInstance]:
	var insts: Array[DlInstance] = []

	for _i in range(count):
		insts.append(DlInstance.new(item))

	return insts


static func instantiate_query(db: DlDatabase, query: DlQuery, count: int = 1) -> Array[DlInstance]:
	var insts: Array[DlInstance] = []
	var result := query.execute(db)

	for id in result:
		var item := db.get_item(id)
		for _i in range(count):
			insts.append(DlInstance.new(item))

	return insts


func set_rng_seed(seed: String) -> void:
	_rng.set_string_seed(seed)


func instances() -> Array[DlInstance]:
	return _content


func instances_filtered(filter: DlQuery) -> Array[DlInstance]:
	var filtered: Array[DlInstance] = []

	for instance in _content:
		if filter.match_item(instance.data()):
			filtered.append(instance)

	return filtered


func is_empty() -> bool:
	return _content.is_empty()


func size() -> int:
	return _content.size()


func sort_by_value(values: Array, asc: bool = true) -> void:
	_content.sort_custom(Callable(ValueSorter.new(values, asc), "sort"))


func sort_by_text(texts: Array, asc: bool = true) -> void:
	_content.sort_custom(Callable(TextSorter.new(texts, asc), "sort"))


func shuffle() -> void:
	# Cannot shuffle arrays of 1 or less element
	if _content.size() <= 1:
		return

	# A random number of swaps will occure
	for i in range(_content.size() * _rng.random_range(2, 6)):
		# Indexes to swap
		var a := _rng.random_range(0, _content.size()-1)
		var b := _rng.random_range(0, _content.size()-1)

		if a == b:
			continue

		# Swap
		var tmp := _content[a]
		_content[a] = _content[b]
		_content[b] = tmp

	emit_signal("changed")


func insert_back(inst: DlInstance) -> void:
	if _index.has(inst.ref()):
		printerr("Instance already in store")
		return

	_content.append(inst)
	_index[inst.ref()] = inst
	emit_signal("inserted", inst)
	emit_signal("changed")


# Should be Array[DlInstance], see https://github.com/godotengine/godot/issues/53771
func insert_back_multi(insts: Array) -> void:
	for inst in insts:
		insert_back(inst)


func insert_front(inst: DlInstance) -> void:
	if _index.has(inst.ref()):
		printerr("Instance already in store")
		return

	_content.push_front(inst)
	_index[inst.ref()] = inst
	emit_signal("inserted", inst)
	emit_signal("changed")


# Should be Array[DlInstance], see https://github.com/godotengine/godot/issues/53771
func insert_front_multi(insts: Array) -> void:
	for inst in insts:
		insert_front(inst)


func insert_at(inst: DlInstance, position: int) -> void:
	if _index.has(inst.ref()):
		printerr("Instance already in store")
		return

	if position < 0 or position > _content.size():
		printerr("Insert position out of bound: %d" % position)
		return

	_content.insert(position, inst)
	_index[inst.ref()] = inst
	emit_signal("inserted", inst)
	emit_signal("changed")


func insert_at_random(inst: DlInstance) -> void:
	insert_at(inst, _rng.random_range(0, _content.size()-1))


func get_instance(instance_ref: int) -> DlInstance:
	if not _index.has(instance_ref):
		return null

	return _index[instance_ref]


func random_instance() -> DlInstance:
	return _content[_rng.random_range(0, _content.size()-1)]


func pop_back() -> DlInstance:
	var inst := _content.pop_back() as DlInstance

	if inst == null:
		return null

	_index.erase(inst.ref())
	emit_signal("removed", inst)
	emit_signal("changed")
	return inst


func pop_front() -> DlInstance:
	var inst := _content.pop_front() as DlInstance

	if inst == null:
		return null

	_index.erase(inst.ref())
	emit_signal("removed", inst)
	emit_signal("changed")
	return inst


func pop_at(position: int) -> DlInstance:
	if position < 0 or position > _content.size():
		printerr("Insert position out of bound: %d" % position)
		return

	var inst := _content.pop_at(position) as DlInstance
	_index.erase(inst.ref())
	emit_signal("removed", inst)
	emit_signal("changed")
	return inst


func pop_random() -> DlInstance:
	return pop_at(_rng.random_range(0, _content.size()-1))


func remove(instance_ref: int) -> void:
	if not _index.has(instance_ref):
		printerr("Instance not in store")
		return

	var inst = _index[instance_ref]
	_index.erase(instance_ref)
	_content.erase(inst)
	emit_signal("removed", inst)
	emit_signal("changed")


func remove_random() -> void:
	var inst := random_instance()
	_index.erase(inst.ref())
	_content.erase(inst)
	emit_signal("removed", inst)
	emit_signal("changed")
