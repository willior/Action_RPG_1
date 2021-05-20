extends Node
# GameManager initializes the player by getting a reference to them,
# then it emits a "player_initialized" signal to be listened for by the UI;
# this signal will connect the UI to the player inventory;
# meaning any changes reflected in the inventory will be reflected in the UI;
# when the program is first run, it attempts to load the inventory resource from a file;
# if it can't, it gives the player 2 potions instead;
# when the player is reinitialized, the old inventory is stored,
# and used as the argument to run the "reinitialize_player" function,
# which sets the current player scene's inventory to that of the argument's.

var on_title_screen = false
var player
var player2
var multiplayer_2 = false
var player2_data = [null, null]

var file_inventory
var file_pouch
var file_formulabook

var inventory_resource = load("res://assets/Player/Inventory.gd")
var inventory_r = inventory_resource.new()
var pouch_resource = load("res://assets/Player/Pouch.gd")
var pouch_r = pouch_resource.new()
var formulabook_resource = load("res://assets/Player/FormulaBook.gd")
var formulabook_r = formulabook_resource.new()

signal player_initialized
signal player_reinitialized
signal player2_initialized
signal player2_reinitialized

func _ready():
	# when the game runs, checks for resource files, and creates empty ones if none exist.
	if !ResourceLoader.exists("res://Save/inventory.tres"):
		file_inventory = inventory_r
# warning-ignore:return_value_discarded
		ResourceSaver.save("res://Save/inventory.tres", file_inventory)
	
	if !ResourceLoader.exists("res://Save/pouch.tres"):
		file_pouch = pouch_r
# warning-ignore:return_value_discarded
		ResourceSaver.save("res://Save/pouch.tres", file_pouch)
	
	if !ResourceLoader.exists("res://Save/formulabook.tres"):
		file_formulabook = formulabook_r
# warning-ignore:return_value_discarded
		ResourceSaver.save("res://Save/formulabook.tres", file_formulabook)

func initialize_player():
	print('initializing player 1...')
	player = get_tree().get_root().get_node("/root/World/YSort/Player")
	emit_signal("player_initialized", player)
	if file_inventory and file_pouch and file_formulabook:
		print('resources found. continuing initialization.')
		player.inventory.set_items(file_inventory.get_items())
		player.pouch.set_ingredients(file_pouch.get_ingredients())
		player.formulabook.set_formulas(file_formulabook.get_formulas())
	else:
		print('resources not found. giving formulas/ingredients.')
		player.pouch.add_ingredient("Rock", 20)
		player.pouch.add_ingredient("Clay", 20)
		player.pouch.add_ingredient("Water", 20)
		player.pouch.add_ingredient("Salt", 20)
		player.formulabook.add_formula("Flash")
		player.formulabook.add_formula("Heal")
		player.formulabook.add_formula("Fury")
	print('player 1 initialized.')

func reinitialize_player(inventory, pouch, formulabook):
	print('attempting to reinitialize player...')
	player = get_tree().get_root().get_node("/root/World/YSort/Player")
	if not player:
		return
	emit_signal("player_reinitialized", player) 
	player.inventory.set_items(inventory.get_items())
	player.pouch.set_ingredients(pouch.get_ingredients())
	player.formulabook.set_formulas(formulabook.get_formulas())
	print('player reinitialized.')

#func old_initialize_player():
#	print('attempting to initialize player...')
#	player = get_tree().get_root().get_node("/root/World/YSort/Player")
#	if not player:
#		print('player not created; cannot initialize.')
#		return
#	emit_signal("player_initialized", player)
#	player.inventory.connect("inventory_changed", self, "_on_player_inventory_changed")
#	player.pouch.connect("pouch_changed", self, "_on_player_pouch_changed")
#	player.formulabook.connect("formulabook_changed", self, "_on_player_formulabook_changed")
#	print('player successfully initialized.')
#
#	if !ResourceLoader.exists("res://Save/inventory.tres"):
#		print("inventory resource not found. creating...")
#		player.inventory.add_item("Potion", 3)
#		# warning-ignore:return_value_discarded
#		ResourceSaver.save("res://Save/inventory.tres", player.inventory)
#		prints("saved inventory resource to " + str(OS.get_user_data_dir()))
#	else:
#		var loaded_inventory = load("res://Save/inventory.tres")
#		if loaded_inventory:
#			player.inventory.set_items(loaded_inventory.get_items())
#			print("inventory loaded from disk.")
#
#	if !ResourceLoader.exists("res://Save/pouch.tres"):
#		print("pouch resource not found. creating...")
##		player.pouch.add_ingredient("Rock", 20)
##		player.pouch.add_ingredient("Clay", 20)
##		player.pouch.add_ingredient("Salt", 20)
##		player.pouch.add_ingredient("Water", 20)
#		# warning-ignore:return_value_discarded
#		ResourceSaver.save("res://Save/pouch.tres", player.pouch)
#		prints("saved pouch resource to " + str(OS.get_user_data_dir()))
#	else:
#		var loaded_pouch = load("res://Save/pouch.tres")
#		if loaded_pouch:
#			player.pouch.set_ingredients(loaded_pouch.get_ingredients())
#			print("pouch loaded from disk.")
#
#	if !ResourceLoader.exists("res://Save/formulabook.tres"):
#		print("formulabook resource not found. creating...")
#		player.formulabook.add_formula("Flash")
#		player.formulabook.add_formula("Heal")
#		player.formulabook.add_formula("Fury")
#		# warning-ignore:return_value_discarded
#		ResourceSaver.save("res://Save/formulabook.tres", player.formulabook)
#		prints("saved formulabook resource to " + str(OS.get_user_data_dir()))
#	else:
#		var loaded_formulabook = load("res://Save/formulabook.tres")
#		if loaded_formulabook:
#			player.formulabook.set_formulas(loaded_formulabook.get_formulas())
#			print("formulabook loaded from disk.")

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

func multiplayer_2_toggle():
	if multiplayer_2: # OFF TOGGLE
		player2_data[0] = player2.pouch
		player2_data[1] = player2.formulabook
		var REMOTE2D = load("res://assets/System/RemoteTransform2D.tscn")
		var remoteTransform2D = REMOTE2D.instance()
		player.add_child(remoteTransform2D)
		get_tree().get_root().get_node("/root/World/Camera2D").state = 0
		player2.queue_free()
		multiplayer_2 = false
	else: # ON TOGGLE
		player.get_node("RemoteTransform2D").queue_free()
		player2 = load("res://assets/Player/Player2.tscn").instance()
		get_tree().get_root().get_node("/root/World/YSort").add_child(player2)
		get_tree().get_root().get_node("/root/World/Camera2D").state = 1
		player2.global_position = player.global_position
	get_tree().get_root().get_node("/root/World/GUI").toggle_multiplayer_gui()

func save_game():
	var save_game = File.new()
	save_game.open("res://Save/savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		if !node.has_method("save"):
			print("persistent node '%s' does not have a save method, skipped" % node.name)
			continue
		var node_data = node.call("save")
		save_game.store_line(to_json(node_data))
	save_game.close()

func load_game():
	var map_path
	var save_game = File.new()
	if not save_game.file_exists("res://Save/savegame.save"):
		print('error: no save file found')
		return
	save_game.open("res://Save/savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		for i in node_data.keys():
			if i == "map_filename":
				map_path = node_data["map_filename"]
				continue
			else:
				PlayerStats.set(i, node_data[i])
				PlayerLog.set(i, node_data[i])
	load_player_resources()
	Global.goto_scene(map_path)
	save_game.close()

func load_player_resources():
	if !ResourceLoader.exists("res://Save/inventory.tres"):
		file_inventory = inventory_r
# warning-ignore:return_value_discarded
		ResourceSaver.save("res://Save/inventory.tres", file_inventory)
	else:
		file_inventory = load("res://Save/inventory.tres")
	
	if !ResourceLoader.exists("res://Save/pouch.tres"):
		file_pouch = pouch_r
# warning-ignore:return_value_discarded
		ResourceSaver.save("res://Save/pouch.tres", file_pouch)
	else:
		file_pouch = load("res://Save/pouch.tres")
	
	if !ResourceLoader.exists("res://Save/formulabook.tres"):
		file_formulabook = formulabook_r
# warning-ignore:return_value_discarded
		ResourceSaver.save("res://Save/formulabook.tres", file_formulabook)
	else:
		file_formulabook = load("res://Save/formulabook.tres")

func quit_to_title():
	get_tree().paused = false
	Global.goto_scene("res://assets/System/MainMenu.tscn")
	file_inventory = inventory_r
	file_pouch = pouch_r
	file_formulabook = formulabook_r
	PlayerStats.default_stats()
	PlayerLog.reset_player_log()

func new_game():
	file_inventory = inventory_r
	file_pouch = pouch_r
	file_formulabook = formulabook_r
	Global.goto_scene("res://assets/Maps/0_Prologue/0-1_Home.tscn")

# warning-ignore:unused_argument
func _on_player_inventory_changed(inventory):
	pass

# warning-ignore:unused_argument
func _on_player_pouch_changed(pouch):
	pass

# warning-ignore:unused_argument
func _on_player_formulabook_changed(formulabook):
	pass
