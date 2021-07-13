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
var multiplayer_2 = true

# variables from which we intialize Player resources
# empty when we quit to title or select new game
# load from disk when we select Continue
var p1_pouch
var p1_formulabook
var p2_pouch
var p2_formulabook

# variable to store player2 data when multiplayer is toggled off
var player2_data = [null, null]

signal player_initialized
signal player_reinitialized
signal player2_initialized
signal player2_reinitialized

func initialize_player(player_name):
	match player_name:
		"Player":
			player = get_tree().get_root().get_node("/root/World/YSort/Player")
			emit_signal("player_initialized", player)
			if p1_pouch != null and p1_formulabook != null:
				print('setting loaded resources')
				player.pouch.set_ingredients(p1_pouch.get_ingredients())
				player.formulabook.set_formulas(p1_formulabook.get_formulas())
				p1_pouch = null
				p1_formulabook = null
		"Player2":
			player2 = get_tree().get_root().get_node("/root/World/YSort/Player2")
			emit_signal("player2_initialized", player2)
			if p2_pouch != null and p2_formulabook != null:
				player2.pouch.set_ingredients(p2_pouch.get_ingredients())
				player2.formulabook.set_formulas(p2_formulabook.get_formulas())
			player2_data[0] = player2.pouch
			player2_data[1] = player2.formulabook
			p2_pouch = null
			p2_formulabook = null

func reinitialize_player(player_name):
	match player_name:
		"Player":
			player = get_tree().get_root().get_node("/root/World/YSort/Player")
			emit_signal("player_reinitialized", player) 
#			player.pouch.set_ingredients(pouch.get_ingredients())
#			player.formulabook.set_formulas(formulabook.get_formulas())
		"Player2":
			player2 = get_tree().get_root().get_node("/root/World/YSort/Player2")
			emit_signal("player2_reinitialized", player2) 
#			player2.pouch.set_ingredients(pouch.get_ingredients())
#			player2.formulabook.set_formulas(formulabook.get_formulas())

func multiplayer_2_toggle():
	if multiplayer_2: # OFF TOGGLE
		if player2.state != 0 or player2.dying:
			print('player2 tried quitting while not idle; returning')
			return
		player2_data[0] = player2.pouch
		player2_data[1] = player2.formulabook
		var REMOTE2D = load("res://assets/System/RemoteTransform2D.tscn")
		var remoteTransform2D = REMOTE2D.instance()
		player.add_child(remoteTransform2D)
		# get_tree().get_root().get_node("/root/World/Camera2D").state = 0
		get_tree().get_root().get_node("/root/World/Camera2D").multiplayer_2_toggle()
		player2.queue_free()
		multiplayer_2 = false
		player2 = null
	else: # ON TOGGLE
		multiplayer_2 = true
		player.get_node("RemoteTransform2D").queue_free()
		load_player2()
		get_tree().get_root().get_node("/root/World/YSort").add_child(player2)
		# get_tree().get_root().get_node("/root/World/Camera2D").state = 1
		get_tree().get_root().get_node("/root/World/Camera2D").multiplayer_2_toggle()
		player2.global_position = player.global_position
	get_tree().get_root().get_node("/root/World/GUI").toggle_multiplayer_gui()

func load_player2():
	player2 = load("res://assets/Player/Player.tscn").instance()
	player2.name = "Player2"
	player2.stats = Player2Stats
	player2.formulaData = P2FormulaData
	player2.inventory_ref = "inventory_2"
	player2.get_node("Sprite").texture = load("res://assets/Player/Player2.png")
	player2.player_inputs = {
		"left": "left_2",
		"right": "right_2",
		"up": "up_2",
		"down": "down_2",
		"attack": "attack_2",
		"roll": "roll_2",
		"examine": "examine_2",
		"alchemy": "alchemy_2",
		"previous": "previous_2",
		"next": "next_2",
		"start": "start_2",
		"select": "select_2"
	}
	return player2

func new_game():
	PlayerLog.reset_player_log()
	Player1Stats.default_stats()
	Player2Stats.default_stats()
	P1FormulaData.default_formula_data()
	P2FormulaData.default_formula_data()
	p1_pouch = load("res://assets/System/InventoryResources/empty_pouch.tres")
	p1_formulabook = load("res://assets/System/InventoryResources/empty_formulabook.tres")
	p2_pouch = load("res://assets/System/InventoryResources/empty_pouch.tres").duplicate()
	p2_formulabook = load("res://assets/System/InventoryResources/empty_formulabook.tres").duplicate()
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
	save_resources()
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
					Player1Stats.set(s, player1_stats[s])
					continue
				continue
			elif i == "player2_stats":
				var player2_stats = node_data["player2_stats"]
				for s in player2_stats:
					Player2Stats.set(s, player2_stats[s])
					continue
				continue
			elif i == "player1_formulaData":
				var player1_formulaData = node_data["player1_formulaData"]
				for f in player1_formulaData:
					P1FormulaData.set(f, player1_formulaData[f])
					continue
			elif i == "player2_formulaData":
				var player2_formulaData = node_data["player2_formulaData"]
				for f in player2_formulaData:
					P2FormulaData.set(f, player2_formulaData[f])
					continue
			else:
				PlayerLog.set(i, node_data[i])
	load_resources()
	Global.goto_scene(map_path)
	save_game.close()

func save_resources():
# warning-ignore:return_value_discarded
	ResourceSaver.save("res://Save/p1_pouch.tres", player.pouch)
# warning-ignore:return_value_discarded
	ResourceSaver.save("res://Save/p1_formulabook.tres", player.formulabook)
	if player2 == null:
		print('player2 is null. checking for last known resources to disk.')
		if player2_data[0] == null:
			print('player2_data is null. not saving.')
			return
		else:
			print('last known data detected; saving to disk.')
		# warning-ignore:return_value_discarded
			ResourceSaver.save("res://Save/p2_pouch.tres", player2_data[0])
		# warning-ignore:return_value_discarded
			ResourceSaver.save("res://Save/p2_formulabook.tres", player2_data[1])
			return
	else:
		print('saving player 2 resources.')
	# warning-ignore:return_value_discarded
		ResourceSaver.save("res://Save/p2_pouch.tres", player2.pouch)
	# warning-ignore:return_value_discarded
		ResourceSaver.save("res://Save/p2_formulabook.tres", player2.formulabook)

func load_resources():
	p1_pouch = load("res://Save/p1_pouch.tres")
	p1_formulabook = load("res://Save/p1_formulabook.tres")
	if ResourceLoader.exists("res://Save/p2_pouch.tres"):
		p2_pouch = load("res://Save/p2_pouch.tres")
	else:
		print('p2_pouch.tres not found; cannot load')
	if ResourceLoader.exists("res://Save/p2_formulabook.tres"):
		p2_formulabook = load("res://Save/p2_formulabook.tres")
	else:
		print('p2_formulabook.tres not found; cannot load')

func reset_resources():
	p1_pouch = null
	p1_formulabook = null
	p2_pouch = null
	p2_formulabook = null

func quit_to_title():
	Engine.time_scale = 1
	get_tree().paused = false
	Global.goto_scene("res://assets/System/MainMenu.tscn")
	reset_resources()
	PlayerLog.reset_player_log()
	Player1Stats.reset_stats()
	Player2Stats.reset_stats()
	P1FormulaData.default_formula_data()
	P2FormulaData.default_formula_data()

# warning-ignore:unused_argument
func _on_player_inventory_changed(inventory):
	pass

# warning-ignore:unused_argument
func _on_player_pouch_changed(pouch):
	pass

# warning-ignore:unused_argument
func _on_player_formulabook_changed(formulabook):
	pass
