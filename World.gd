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
		player2 = GameManager.load_player2()

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
	
	if event.is_action_pressed("test1"):
		print('1: giving formulas/ingredients')
		GameManager.player.formulabook.add_formula("Flash")
		GameManager.player.formulabook.add_formula("Heal")
		GameManager.player.formulabook.add_formula("Fury")
		GameManager.player.pouch.add_ingredient("Rock", 20)
		GameManager.player.pouch.add_ingredient("Clay", 10)
		GameManager.player.pouch.add_ingredient("Water", 20)
		GameManager.player.pouch.add_ingredient("Salt", 10)
		if GameManager.multiplayer_2:
			GameManager.player2.formulabook.add_formula("Flash")
			GameManager.player2.formulabook.add_formula("Heal")
			GameManager.player2.formulabook.add_formula("Fury")
			GameManager.player2.pouch.add_ingredient("Rock", 20)
			GameManager.player2.pouch.add_ingredient("Clay", 10)
			GameManager.player2.pouch.add_ingredient("Water", 20)
			GameManager.player2.pouch.add_ingredient("Salt", 10)
		else:
			print('no P2. cannot give ingredients.')
	if event.is_action_pressed("test2"):
		print('2: resetting player interaction')
		for p in get_tree().get_nodes_in_group("Players"):
			p.reset_interaction()
	if event.is_action_pressed("test3"):
		print('3: no use!')
	if event.is_action_pressed("test4"):
		print('4: leveling up')
		GameManager.player.level_up()
		if GameManager.multiplayer_2:
			GameManager.player2.level_up()
		else:
			print('no P2. cannot level.')
	if event.is_action_pressed("test5"):
		print('5: damaging P1.')
		GameManager.player.stats.health -= 1000
	if event.is_action_pressed("test6"):
		print('6: damaging P2.')
		GameManager.player2.stats.health -= 1000
	if event.is_action_pressed("test7"):
		print('7: recovering P1 health.')
		GameManager.player.stats.health += 1000
	if event.is_action_pressed("test8"):
		print('8: recovering P2 health.')
		GameManager.player2.stats.health += 1000
	
	if event.is_action_pressed("select_2"):
		GameManager.multiplayer_2_toggle()
	
	if event.is_action_pressed("start"): # SPACEBAR
		if Global.dialogOpen or Global.chapter_name or Global.changingScene or (Player1Stats.dying and !Player1Stats.dead):
			print('start discarded')
			return
		if Player1Stats.dead:
			get_node("/root/World/GUI/GameOver").queue_free()
			GameManager.quit_to_title()
		elif get_tree().paused == false:
			open_pause_menu(GameManager.player)
	if event.is_action_pressed("start_2"):
		if !GameManager.multiplayer_2 or Global.dialogOpen or Global.chapter_name or Global.changingScene or (Player2Stats.dying and !Player2Stats.dead):
			print('start discarded: ', Global.changingScene)
			return
		if Player2Stats.dead:
			get_node("/root/World/GUI/GameOver").queue_free()
			GameManager.quit_to_title()
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
