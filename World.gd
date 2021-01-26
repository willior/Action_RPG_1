extends Node2D

onready var stats = $GUI/StatsDisplay
onready var dim = $GUI/Dim
onready var music = $Music
onready var player = $YSort/Player
onready var FadeOut = load("res://assets/Misc/FadeOut.tscn")

func _ready():
	$SFX.play()
	$SFX2.play()
	if GameManager.on_title_screen:
		GameManager.on_title_screen = false
		
	if Global.chapter_display:
		$FadeIn.free()
		var chapterDisplay = load("res://assets/Misc/ChapterDisplay.tscn").instance()
		add_child(chapterDisplay)
		
func fade_out():
	var fadeout = FadeOut.instance()
	add_child(fadeout)

func _input(event):
	if event.is_action_pressed("quit_game"):
		get_tree().quit()
	
	if event.is_action_pressed("test1"): # T
		print('test2: applying frenzy')
		PlayerStats.status = "frenzy"
		
	if event.is_action_pressed("test2"): # Y
		player.level_up()
	
	if event.is_action_pressed("test3"): # U
		pass
	
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
		if Global.dialogOpen or Global.chapter_display or Global.changingScene or PlayerStats.dying and !PlayerStats.dead:
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
