extends Node2D

onready var music = $Music
onready var sfx1 = $SFX
onready var sfx2 = $SFX2
onready var dim = $GUI/Dim
onready var FadeIn = load("res://assets/Misc/FadeIn.tscn")
onready var FadeOut = load("res://assets/Misc/FadeOut.tscn")
onready var PauseScreen = load("res://assets/UI/Menu/PauseScreen.tscn")

var remoteTransform2D
var player
var player2

func _init():
	player = load("res://assets/Player/Player.tscn").instance()
	if !GameManager.multiplayer_2:
		var REMOTE2D = load("res://assets/System/RemoteTransform2D.tscn")
		remoteTransform2D = REMOTE2D.instance()
	else:
		player2 = load("res://assets/Player/Player.tscn").instance()
		player2.name = "Player2"
		player2.stats = Player2Stats
		player2.formulaData = P2FormulaData
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

func _ready():
	get_node("YSort").add_child(player)
	if !GameManager.multiplayer_2:
		get_tree().get_root().get_node("/root/World/Camera2D").state = 0
		player.add_child(remoteTransform2D)
	else:
		get_tree().get_root().get_node("/root/World/Camera2D").state = 1
		player2.global_position = player.global_position
		get_node("YSort").add_child(player2)
	sfx1.play()
	sfx2.play()
	if GameManager.on_title_screen:
		GameManager.on_title_screen = false
	if Global.chapter_name != null:
		var chapterDisplay = load("res://assets/Misc/ChapterDisplay.tscn").instance()
		add_child(chapterDisplay)
		get_node("ChapterDisplay/Chapter").text = Global.chapter_name
		Global.chapter_name = null
	else:
		var fade_in = FadeIn.instance()
		add_child(fade_in)
	player = GameManager.player
	player2 = GameManager.player2

func fade_out():
	var fadeout = FadeOut.instance()
	add_child(fadeout)

func _input(event):
	if event.is_action_pressed("quit_game"):
		GameManager.quit_to_title()
	
	if event.is_action_pressed("test1"): # T
		GameManager.player.formulabook.add_formula("Flash")
		GameManager.player.formulabook.add_formula("Heal")
		GameManager.player.formulabook.add_formula("Fury")
		if GameManager.multiplayer_2:
			GameManager.player2.formulabook.add_formula("Flash")
			GameManager.player2.formulabook.add_formula("Heal")
			GameManager.player2.formulabook.add_formula("Fury")
	
	if event.is_action_pressed("test2"): # Y
#		print("p1 pouch: ", player.pouch._ingredients)
#		if GameManager.multiplayer_2:
#			print("p2 pouch: ", player2.pouch._ingredients)
		GameManager.player.level_up()
		if GameManager.multiplayer_2:
			GameManager.player2.level_up()
	
	if event.is_action_pressed("test3"): # U
		print('adding ingredients...')
		GameManager.player.pouch.add_ingredient("Rock", 20)
		GameManager.player.pouch.add_ingredient("Clay", 10)
		GameManager.player.pouch.add_ingredient("Water", 20)
		GameManager.player.pouch.add_ingredient("Salt", 10)
		if GameManager.multiplayer_2:
			GameManager.player2.pouch.add_ingredient("Rock", 20)
			GameManager.player2.pouch.add_ingredient("Clay", 10)
			GameManager.player2.pouch.add_ingredient("Water", 20)
			GameManager.player2.pouch.add_ingredient("Salt", 10)
	
	if event.is_action_pressed("test4"): # O
		print(PlayerLog.examined_list)
	
	if event.is_action_pressed("select_2"):
		GameManager.multiplayer_2_toggle()
	
	if event.is_action_pressed("start"): # SPACEBAR
		if Global.dialogOpen or Global.chapter_name or Global.changingScene or (Player1Stats.dying and !Player1Stats.dead):
			print('start discarded')
			return
		if Player1Stats.dead:
			print('resuming')
			music.stream_paused = false
			get_tree().paused = false
			get_node("/root/World/GUI/GameOver").queue_free()
			get_node("/root/World/GUI/HealthUI1").visible = true
			get_node("/root/World/GUI/ExpBar1").visible = true
			get_node("/root/World/GUI/StaminaBar1").visible = true
			get_node("/root/World/GUI/FormulaUI1").visible = true
			get_node("/root/World/YSort/Player").visible = true
			Player1Stats.health += Player1Stats.max_health
			get_node("/root/World/GUI/HealthUI1/HealthBack").value = Player1Stats.health
			Player1Stats.continue_count += 1
			Player1Stats.dead = false
			Player1Stats.experience -= (Player1Stats.experience_required / 10)
		elif get_tree().paused == false:
			open_pause_menu(GameManager.player)

	if event.is_action_pressed("start_2"):
		if !GameManager.multiplayer_2 or Global.dialogOpen or Global.chapter_name or Global.changingScene or (Player2Stats.dying and !Player2Stats.dead):
			print('start discarded: ', Global.changingScene)
			return
		if Player2Stats.dead:
			print('resuming')
			music.stream_paused = false
			get_tree().paused = false
			get_node("/root/World/GUI/GameOver").queue_free()
			get_node("/root/World/GUI/HealthUI2").visible = true
			get_node("/root/World/GUI/ExpBar2").visible = true
			get_node("/root/World/GUI/StaminaBar2").visible = true
			get_node("/root/World/GUI/FormulaUI2").visible = true
			get_node("/root/World/YSort/Player2").visible = true
			Player2Stats.health += Player2Stats.max_health
			get_node("/root/World/GUI/HealthUI2/HealthBack").value = Player2Stats.health
			Player2Stats.continue_count += 1
			Player2Stats.dead = false
			Player2Stats.experience -= (Player2Stats.experience_required / 10)
		elif get_tree().paused == false:
			open_pause_menu(GameManager.player2)

func open_pause_menu(body):
	music.stream_paused = true
	sfx1.stream_paused = true
	sfx2.stream_paused = true
	get_tree().paused = true
	# dim.visible = true
	var pauseScreen = PauseScreen.instance()
	pauseScreen.player = body
	$GUI.add_child(pauseScreen)

func close_pause_menu():
	music.stream_paused = false
	sfx1.stream_paused = false
	sfx2.stream_paused = false
	get_tree().paused = false
	# dim.visible = false
	$GUI/PauseScreen.queue_free()
	GameManager.player.talkTimer.start()

func save():
	var save_dict = {
		"map_filename": get_filename(),
	}
	return save_dict
