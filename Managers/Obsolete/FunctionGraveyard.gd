extends Node
var player
var player2
func old_initialize_player():
	print('attempting to initialize player...')
	player = get_tree().get_root().get_node("/root/World/YSort/Player")
	if not player:
		print('player not created; cannot initialize.')
		return
	emit_signal("player_initialized", player)
	player.inventory.connect("inventory_changed", self, "_on_player_inventory_changed")
	player.pouch.connect("pouch_changed", self, "_on_player_pouch_changed")
	player.formulabook.connect("formulabook_changed", self, "_on_player_formulabook_changed")
	print('player successfully initialized.')

	if !ResourceLoader.exists("res://Save/inventory.tres"):
		print("inventory resource not found. creating...")
		player.inventory.add_item("Potion", 3)
		# warning-ignore:return_value_discarded
		ResourceSaver.save("res://Save/inventory.tres", player.inventory)
		prints("saved inventory resource to " + str(OS.get_user_data_dir()))
	else:
		var loaded_inventory = load("res://Save/inventory.tres")
		if loaded_inventory:
			player.inventory.set_items(loaded_inventory.get_items())
			print("inventory loaded from disk.")

	if !ResourceLoader.exists("res://Save/pouch.tres"):
		print("pouch resource not found. creating...")
#		player.pouch.add_ingredient("Rock", 20)
#		player.pouch.add_ingredient("Clay", 20)
#		player.pouch.add_ingredient("Salt", 20)
#		player.pouch.add_ingredient("Water", 20)
		# warning-ignore:return_value_discarded
		ResourceSaver.save("res://Save/pouch.tres", player.pouch)
		prints("saved pouch resource to " + str(OS.get_user_data_dir()))
	else:
		var loaded_pouch = load("res://Save/pouch.tres")
		if loaded_pouch:
			player.pouch.set_ingredients(loaded_pouch.get_ingredients())
			print("pouch loaded from disk.")

	if !ResourceLoader.exists("res://Save/formulabook.tres"):
		print("formulabook resource not found. creating...")
		player.formulabook.add_formula("Flash")
		player.formulabook.add_formula("Heal")
		player.formulabook.add_formula("Fury")
		# warning-ignore:return_value_discarded
		ResourceSaver.save("res://Save/formulabook.tres", player.formulabook)
		prints("saved formulabook resource to " + str(OS.get_user_data_dir()))
	else:
		var loaded_formulabook = load("res://Save/formulabook.tres")
		if loaded_formulabook:
			player.formulabook.set_formulas(loaded_formulabook.get_formulas())
			print("formulabook loaded from disk.")
func reinitialize_player2(pouch, formulabook):
	print('attempting to reinitialize player2...')
	player2 = get_tree().get_root().get_node("/root/World/YSort/Player2")
	if not player2:
		return
	emit_signal("player2_reinitialized", player2) 
	player2.pouch.set_ingredients(pouch.get_ingredients())
	player2.formulabook.set_formulas(formulabook.get_formulas())
	player2_data[0] = player2.pouch
	player2_data[1] = player2.formulabook
	print('player2 reinitialized.')
	
func initialize_player2():
	print('attempting to initialize player2...')
	player2 = get_tree().get_root().get_node("/root/World/YSort/Player2")
	if not player2:
		print('player2 not created; cannot initialize.')
		return
	emit_signal("player2_initialized", player2)
	player2.pouch.connect("pouch_changed", self, "_on_player_pouch_changed")
	player2.formulabook.connect("formulabook_changed", self, "_on_player_formulabook_changed")
	player2_data[0] = player2.pouch
	player2_data[1] = player2.formulabook
	print('player2 successfully initialized.')
	if !ResourceLoader.exists("res://Save/pouch_2.tres"):
		print("pouch resource not found. creating...")
		player2.pouch.add_ingredient("Rock", 20)
		player2.pouch.add_ingredient("Clay", 20)
		player2.pouch.add_ingredient("Salt", 20)
		player2.pouch.add_ingredient("Water", 20)
		# warning-ignore:return_value_discarded
		ResourceSaver.save("res://Save/pouch_2.tres", player2.pouch)
		prints("saved pouch resource to " + str(OS.get_user_data_dir()))
	else:
		var loaded_pouch = load("res://Save/pouch_2.tres")
		if loaded_pouch:
			player2.pouch.set_ingredients(loaded_pouch.get_ingredients())
			print("pouch loaded from disk.")
	
	if !ResourceLoader.exists("res://Save/formulabook_2.tres"):
		print("formulabook resource not found. creating...")
		player2.formulabook.add_formula("Flash")
		player2.formulabook.add_formula("Heal")
		player2.formulabook.add_formula("Fury")
		# warning-ignore:return_value_discarded
		ResourceSaver.save("res://Save/formulabook_2.tres", player2.formulabook)
		prints("saved formulabook resource to " + str(OS.get_user_data_dir()))
	else:
		var loaded_formulabook = load("res://Save/formulabook_2.tres")
		if loaded_formulabook:
			player2.formulabook.set_formulas(loaded_formulabook.get_formulas())
			print("formulabook loaded from disk.")

