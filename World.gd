extends Node2D

onready var stats = $GUI/StatsDisplay
onready var dim = $GUI/Dim
onready var music = $Music
onready var sfx = $SFX
onready var player = $YSort/Player

func _ready():
	sfx.play()
	music.play()
	if GameManager.on_title_screen:
		GameManager.on_title_screen = false
		
func _input(event):
	if event.is_action_pressed("quit_game"):
		get_tree().quit()
	
	if event.is_action_pressed("test"): # T
		prints("current selected item index: " + str(player.inventory.current_selected_item))
		# PlayerStats.status = "poison"
		
	if event.is_action_pressed("pause"): # P
		if get_tree().paused == false:
			get_tree().paused = true
			dim.visible = true
			stats.visible = true
		else:
			get_tree().paused = false
			dim.visible = false
			stats.visible = false
			
	if event.is_action_pressed("start"): # SPACEBAR
		if Global.dialogOpen:
			return
		if PlayerStats.health <= 0:
			player.dying = false
			music.stream_paused = false
			get_tree().paused = false
			get_node("/root/World/GUI/GameOver").visible = false
			get_node("/root/World/GUI/GameOver").queue_free()
			get_node("/root/World/GUI/HealthUI").visible = true
			get_node("/root/World/GUI/ExpBar").visible = true
			get_node("/root/World/GUI/StaminaBar").visible = true
			get_node("/root/World/YSort/Player").visible = true
			PlayerStats.health += PlayerStats.max_health
			PlayerStats.continue_count += 1
			PlayerStats.experience -= (PlayerStats.experience_required / 10)
			
		elif get_tree().paused == false:
			music.stream_paused = true
			sfx.stream_paused = true
			get_tree().paused = true
			dim.visible = true
			stats.visible = true
		else:
			music.stream_paused = false
			sfx.stream_paused = false
			get_tree().paused = false
			dim.visible = false
			stats.visible = false

func _process(_delta): pass
#	if event.is_action_pressed("quit_game"):
#		get_tree().quit()
#
#	if Input.is_action_just_pressed("next_item"): # R
#		player.inventory.advance_selected_item()
#
#	if Input.is_action_just_pressed("test"): # T
#		# prints("current selected item index: " + str(player.inventory.current_selected_item))
#		PlayerStats.status = "poison"
#
#	if Input.is_action_just_pressed("pause"): # P
#		if get_tree().paused == false:
#			get_tree().paused = true
#			dim.visible = true
#			stats.visible = true
#		else:
#			get_tree().paused = false
#			dim.visible = false
#			stats.visible = false
#
#	if Input.is_action_just_pressed("start"): # SPACEBAR
#		if Global.dialogOpen:
#			return
#		if PlayerStats.health <= 0:
#			player.dying = false
#			music.stream_paused = false
#			get_tree().paused = false
#			get_node("/root/World/GUI/GameOver").visible = false
#			get_node("/root/World/GUI/GameOver").queue_free()
#			get_node("/root/World/GUI/HealthUI").visible = true
#			get_node("/root/World/GUI/ExpBar").visible = true
#			get_node("/root/World/GUI/StaminaBar").visible = true
#			get_node("/root/World/YSort/Player").visible = true
#			PlayerStats.health += PlayerStats.max_health
#			PlayerStats.continue_count += 1
#			PlayerStats.experience -= (PlayerStats.experience_required / 10)
#
#		elif get_tree().paused == false:
#			music.stream_paused = true
#			sfx.stream_paused = true
#			get_tree().paused = true
#			dim.visible = true
#			stats.visible = true
#		else:
#			music.stream_paused = false
#			sfx.stream_paused = false
#			get_tree().paused = false
#			dim.visible = false
#			stats.visible = false
