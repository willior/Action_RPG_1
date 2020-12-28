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
	
	if event.is_action_pressed("test1"): # T
		print('test2: applying frenzy')
		PlayerStats.status = "frenzy"
		
	if event.is_action_pressed("test2"): # Y
		print("test1: applying poison")
		PlayerStats.status = "poison"
		
	if event.is_action_pressed("test3"): # U
		prints('text3: PlayerStats.is_poisoned = ' + str(PlayerStats.is_poisoned))
	
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
