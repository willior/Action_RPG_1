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
		# print("test1: applying poison")
		# PlayerStats.status = "poison"
		print("player hit = ", Global.player_hit_calculation(75, 4, 1, 2))
		
	if event.is_action_pressed("test3"): # U
		if PlayerStats.speed < 40:
			PlayerStats.speed = 40.0
		else:
			PlayerStats.speed = 4.0
	
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
		if Global.dialogOpen or PlayerStats.dying and !PlayerStats.dead:
			return
		if PlayerStats.dead:
			print('resuming')
			music.stream_paused = false
			get_tree().paused = false
			# get_node("/root/World/GUI/GameOver").visible = false
			get_node("/root/World/GUI/GameOver").queue_free()
			get_node("/root/World/GUI/HealthUI").visible = true
			get_node("/root/World/GUI/ExpBar").visible = true
			get_node("/root/World/GUI/StaminaBar").visible = true
			get_node("/root/World/YSort/Player").visible = true
			PlayerStats.health += PlayerStats.max_health
			get_node("/root/World/GUI/HealthUI/HealthBack").value = PlayerStats.health
			PlayerStats.continue_count += 1
			PlayerStats.dead = false
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
