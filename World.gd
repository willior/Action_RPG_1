extends Node2D

onready var music = $Music
onready var player = $YSort/Player
onready var dim = $GUI/Dim
onready var FadeOut = load("res://assets/Misc/FadeOut.tscn")
onready var PauseScreen = load("res://assets/UI/Menu/PauseScreen.tscn")
# onready var stats = $GUI/StatsDisplay

func _ready():
	$SFX.play()
	$SFX2.play()
	if GameManager.on_title_screen:
		GameManager.on_title_screen = false
		
	if Global.chapter_name != null:
		$FadeIn.free()
		var chapterDisplay = load("res://assets/Misc/ChapterDisplay.tscn").instance()
		add_child(chapterDisplay)
		get_node("ChapterDisplay/Chapter").text = Global.chapter_name
		Global.chapter_name = null

	if GameManager.multiplayer_2:
		var player2 = load("res://assets/Player/Player2.tscn").instance()
		player2.global_position = player.global_position
		get_node("YSort").add_child(player2)
		
func fade_out():
	var fadeout = FadeOut.instance()
	add_child(fadeout)
	
#func save_game():
#	print('save_game')
#	var save_game = File.new()
#	save_game.open("user://savegame.save", File.WRITE)
#	var save_nodes = get_tree().get_nodes_in_group("Persist")
#	for node in save_nodes:
#		# Check the node is an instanced scene so it can be instanced again during load.
#		if node.filename.empty():
#			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
#			continue
#
#		# Check the node has a save function.
#		if !node.has_method("save"):
#			print("persistent node '%s' is missing a save() function, skipped" % node.name)
#			continue
#
#		# Call the node's save function.
#		var node_data = node.call("save")
#
#		# Store the save dictionary as a new line in the save file.
#		save_game.store_line(to_json(node_data))
#		save_game.close()
#
#func load_game():
#	print("load_game")
#	var save_game = File.new()
#	if not save_game.file_exists("user://savegame.save"):
#		print("savegame.save does not exist")
#		return # Error! We don't have a save to load.
#
#	# We need to revert the game state so we're not cloning objects
#	# during loading. This will vary wildly depending on the needs of a
#	# project, so take care with this step.
#	# For our example, we will accomplish this by deleting saveable objects.
#	var save_nodes = get_tree().get_nodes_in_group("Persist")
#	for i in save_nodes:
#		# i.queue_free()
#
#		# Load the file line by line and process that dictionary to restore
#		# the object it represents.
#		save_game.open("user://savegame.save", File.READ)
#		while save_game.get_position() < save_game.get_len():
#			# Get the saved dictionary from the next line in the save file
#			var node_data = parse_json(save_game.get_line())
#			for i in node_data.keys():
#				if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
#					continue
#				player.set(i, node_data[i])
#				print(node_data[i])
#
#			save_game.close()

func _input(event):
	if event.is_action_pressed("quit_game"):
		get_tree().quit()
	
	if event.is_action_pressed("test1"): # T
		print('test2: applying frenzy')
		PlayerStats.status = "frenzy"
		
	if event.is_action_pressed("test2"): # Y
		player.level_up()
		if GameManager.multiplayer_2:
			Global.player2.level_up()
	
	if event.is_action_pressed("test3"): # U
		print(player.inventory._items)
		# load_game()
		pass
	
	if event.is_action_pressed("test4"): # O
		get_node("/root/World/Camera2D/ScreenShake").start(0.1, 64, 10, 0)
	
	if event.is_action_pressed("pause"): # P
		player.pouch.add_ingredient("Salt", 2)
		# save_game()
		pass
	
	if event.is_action_pressed("start"): # SPACEBAR
		if Global.dialogOpen or Global.chapter_name or Global.changingScene or PlayerStats.dying and !PlayerStats.dead:
			return
		if PlayerStats.dead:
			print('resuming')
			music.stream_paused = false
			get_tree().paused = false
			# get_node("/root/World/GUI/GameOver").visible = false
			get_node("/root/World/GUI/GameOver").queue_free()
			get_node("/root/World/GUI/HealthUI1").visible = true
			get_node("/root/World/GUI/ExpBar1").visible = true
			get_node("/root/World/GUI/StaminaBar1").visible = true
			get_node("/root/World/YSort/Player").visible = true
			PlayerStats.health += PlayerStats.max_health
			get_node("/root/World/GUI/HealthUI1/HealthBack").value = PlayerStats.health
			PlayerStats.continue_count += 1
			PlayerStats.dead = false
			PlayerStats.experience -= (PlayerStats.experience_required / 10)
			
		elif get_tree().paused == false:
			music.stream_paused = true
			$SFX.stream_paused = true
			$SFX2.stream_paused = true
			get_tree().paused = true
			dim.visible = true
			# stats.visible = true
			var pauseScreen = PauseScreen.instance()
			$GUI.add_child(pauseScreen)

		else:
			music.stream_paused = false
			$SFX.stream_paused = false
			$SFX2.stream_paused = false
			get_tree().paused = false
			dim.visible = false
			# stats.visible = false
			$GUI/PauseScreen.queue_free()
