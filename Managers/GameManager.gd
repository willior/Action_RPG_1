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

var pouch_resource = load("res://assets/Player/Pouch.gd")
var pouch_r = pouch_resource.new()
var formulabook_resource = load("res://assets/Player/FormulaBook.gd")
var formulabook_r = formulabook_resource.new()

var file_pouch
var file_formulabook

var p1_pouch
var p1_formulabook
# var p2_inventory
var p2_pouch
var p2_formulabook

signal player_initialized
signal player_reinitialized
# warning-ignore:unused_signal
signal player2_initialized
# warning-ignore:unused_signal
signal player2_reinitialized

func initialize_player():
	print('initializing player 1...')
	player = get_tree().get_root().get_node("/root/World/YSort/Player")
	emit_signal("player_initialized", player)
	if p1_pouch!=null and p1_formulabook!=null:
		print('resources found. continuing initialization.')
		# player.inventory.set_items(p1_inventory.get_items())
		player.pouch.set_ingredients(p1_pouch.get_ingredients())
		player.formulabook.set_formulas(p1_formulabook.get_formulas())
	else:
		print('resources not found. giving formulas/ingredients.')
		player.pouch.add_ingredient("Rock", 10)
		player.pouch.add_ingredient("Clay", 10)
		player.pouch.add_ingredient("Water", 10)
		player.pouch.add_ingredient("Salt", 10)
		player.formulabook.add_formula("Flash")
		player.formulabook.add_formula("Heal")
		player.formulabook.add_formula("Fury")
	print('player 1 initialized.')

func reinitialize_player(pouch, formulabook):
	print('attempting to reinitialize player...')
	player = get_tree().get_root().get_node("/root/World/YSort/Player")
	if not player:
		return
	emit_signal("player_reinitialized", player) 
	# player.inventory.set_items(inventory.get_items())
	player.pouch.set_ingredients(pouch.get_ingredients())
	player.formulabook.set_formulas(formulabook.get_formulas())
	print('player reinitialized.')

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

func new_game():
	# p1_inventory = inventory_r
	p1_pouch = pouch_r
	p1_formulabook = formulabook_r
	Global.goto_scene("res://assets/Maps/0_Prologue/0-1_Home.tscn")

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
	save_p1_resources()
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
			elif i == "player1_stats":
				var player1_stats = node_data["player1_stats"]
				for s in player1_stats:
					PlayerStats.set(s, player1_stats[s])
					continue
				continue
			elif i == "player2_stats":
				var player2_stats = node_data["player2_stats"]
				for s in player2_stats:
					Player2Stats.set(s, player2_stats[s])
					continue
				continue
			else:
				PlayerLog.set(i, node_data[i])
	load_p1_resources()
	Global.goto_scene(map_path)
	save_game.close()

func save_p1_resources():
# warning-ignore:return_value_discarded
	ResourceSaver.save("res://Save/p1_pouch.tres", player.pouch)
# warning-ignore:return_value_discarded
	ResourceSaver.save("res://Save/p1_formulabook.tres", player.formulabook)

func load_p1_resources():
	p1_pouch = load("res://Save/p1_pouch.tres")
	p1_formulabook = load("res://Save/p1_formulabook.tres")

func quit_to_title():
	get_tree().paused = false
	Global.goto_scene("res://assets/System/MainMenu.tscn")
	p1_pouch = pouch_r
	p1_formulabook = formulabook_r
	PlayerStats.default_stats()
	PlayerLog.reset_player_log()

# warning-ignore:unused_argument
func _on_player_inventory_changed(inventory):
	pass

# warning-ignore:unused_argument
func _on_player_pouch_changed(pouch):
	pass

# warning-ignore:unused_argument
func _on_player_formulabook_changed(formulabook):
	pass
