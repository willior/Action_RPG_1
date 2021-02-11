extends Node2D

onready var music = $Music
onready var player = $YSort/Player
onready var FadeOut = load("res://assets/Misc/FadeOut.tscn")
onready var stats = $GUI/StatsDisplay
onready var dim = $GUI/Dim

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
	
func save_game():
	print('save_game')
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
	
		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
	
		# Call the node's save function.
		var node_data = node.call("save")
		
		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
		save_game.close()

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
		print(get_tree().get_nodes_in_group("Persist"))
	
	if event.is_action_pressed("pause"): # P
		save_game()
			
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
			stats.visible = true
		else:
			music.stream_paused = false
			$SFX.stream_paused = false
			$SFX2.stream_paused = false
			get_tree().paused = false
			dim.visible = false
			stats.visible = false
