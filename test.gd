extends Panel


func _on_TestBtn_pressed() -> void:
	print("Test launched")

	var db := Datalogue.get_database("weapons")
	var query := DlQuery.new()

	var result := query.execute(db)
	print("All: ", result)

	result = query.from("combat_type", "melee").execute(db)
	print("Melee weapons: ", result)

	result = query.clear().from("combat_type", "launchers").execute(db)
	print("Launchers weapons: ", result)

	result = query.clear().from("type", "magical").execute(db)
	print("Magical weapons: ", result)

	result = query.clear().from("type", "magical").from("type", "hammer").execute(db)
	print("Magical and hammers: ", result)

	result = query.clear().from("type", "sword").or_begin().from("type", "hammer").execute(db)
	print("Swords or hammers: ", result)

	result = query.clear().where("damage", "<=", 10).execute(db)
	print("Damage <= 10: ", result)

	result = query.clear().where("value", ">", 400).execute(db)
	print("Value > 400: ", result)

	result = query.clear().where("range", "=", 100).execute(db)
	print("Range = 100: ", result)

	result = query.clear().where("range", "=", 100).where("damage", "<", 20).execute(db)
	print("Range = 100 and damage < 20: ", result)

	result = query.clear().where("range", "=", 1).or_begin().where("range", "=", 1.5).execute(db)
	print("Range = 1 or range = 1.5: ", result)

	result = query.clear().contains("name", "bow").execute(db)
	print("Name contains bow: ", result)

	result = query.clear().contains("desc", "sword").execute(db)
	print("Description contains sword: ", result)

	result = query.clear().contains("desc", "this").or_begin().contains("desc", "there").execute(db)
	print("Description contains this or these: ", result)

	result = query.clear().from("combat_type", "melee").where("damage", ">=", 10).contains("desc", "sword").execute(db)
	print("Melee weapons with damage >= 10 and description contains sword: ", result)

	var store := DlStore.new()
	store.insert_back_multi(DlStore.instantiate_query(db, DlQuery.new()))

	print("insert_back_multi:")
	for inst in store.instances():
		print("  - %s (%X) " % [inst.id(), inst.ref()])

	var scimitar := db.get_item("scimitar")
	store.insert_front_multi(DlStore.instanciate_multi(scimitar, 5))

	print("insert_front_multi:")
	for inst in store.instances():
		print("  - %s (%X) " % [inst.id(), inst.ref()])

	store.set_rng_seed("ABC123DEF")
	store.shuffle()

	print("shuffle:")
	for inst in store.instances():
		print("  - %s (%X) " % [inst.id(), inst.ref()])

	var back := store.pop_back()
	print("pop_back: %s (%X) " % [back.id(), back.ref()])

	var front := store.pop_front()
	print("pop_front: %s (%X) " % [front.id(), front.ref()])

	var random := store.pop_random()
	print("pop_random: %s (%X) " % [random.id(), random.ref()])

	print("Final store state:")
	for inst in store.instances():
		print("  - %s (%X) " % [inst.id(), inst.ref()])

	print("Test finished")
