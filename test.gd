extends Panel


func _on_TestBtn_pressed() -> void:
	print("Test launched")
	
	var db := Datalogue.get_database("weapons")
	var query := DlQuery.new()
	
	var result := query.from(["combat_type:melee"]).execute(db)
	print("Melee weapons: ", result)
	
	result = query.clear().from(["combat_type:launchers"]).execute(db)
	print("Launchers weapons: ", result)
	
	result = query.clear().from(["type:magical"]).execute(db)
	print("Magical weapons: ", result)
	
	result = query.clear().from(["type:magical,type:hammer"]).execute(db)
	print("Magical hammers: ", result)
	
	result = query.clear().from(["type:hammer", "type:sword"]).execute(db)
	print("Swords and hammers: ", result)
	
	result = query.clear().where(["damage <= 10"]).execute(db)
	print("Damage <= 10: ", result)
	
	result = query.clear().where(["value > 400"]).execute(db)
	print("Value > 400: ", result)
	
	result = query.clear().where(["range = 100"]).execute(db)
	print("Range = 100: ", result)
	
	result = query.clear().where(["range = 100, damage < 20"]).execute(db)
	print("Range = 100 and damage < 20: ", result)
	
	result = query.clear().where(["range = 1", "range = 1.5"]).execute(db)
	print("Range = 1 or range = 1.5: ", result)
	
	result = query.clear().contains(["name:bow"]).execute(db)
	print("Name contains bow: ", result)
	
	result = query.clear().contains(["desc:sword"]).execute(db)
	print("Description contains sword: ", result)
	
	result = query.clear().contains(["desc:this", "desc:these"]).execute(db)
	print("Description contains this or these: ", result)
	
	result = query.clear().from(["combat_type:melee"]).where(["damage >= 10"]).contains(["desc:sword"]).execute(db)
	print("Melee weapons with damage >= 10 and description contains sword: ", result)
	
	print("Test finished")
