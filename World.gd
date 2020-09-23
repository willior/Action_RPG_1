extends Node2D

onready var dim = $GUI/Dim
onready var timer = $Timer
onready var music = $Music

const BAT = preload("res://assets/Enemies/Bat.tscn")

var count = 0

func spawner():
	if count > 20:
		return
	
	else:
		timer.start()
		yield(timer, "timeout")
		var batSpawn = BAT.instance()
		batSpawn.position.x = 72
		batSpawn.position.y = 120
		get_node("/root/World/YSort").add_child(batSpawn)
		spawner()
		count =+ 1
	

func _ready():
	music.play()

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused == false:
			get_tree().paused = true
			dim.visible = true
		else:
			get_tree().paused = false
			dim.visible = false
			
	if Input.is_action_just_pressed("start"):
		if get_node("/root/World/YSort/Player").talking:
			return
		if PlayerStats.health <= 0:
			music.stream_paused = false
			get_tree().paused = false
			get_node("/root/World/GUI/GameOver").visible = false
			get_node("/root/World/GUI/GameOver").queue_free()
			get_node("/root/World/GUI/HealthUI").visible = true
			get_node("/root/World/GUI/ExpBar").visible = true
			get_node("/root/World/GUI/StaminaBar").visible = true
			get_node("/root/World/YSort/Player").visible = true
			PlayerStats.health += 1
			PlayerStats.continue_count += 1
			PlayerStats.experience -= (PlayerStats.experience_required / 10)
			
		elif get_tree().paused == false:
			music.stream_paused = true
			get_tree().paused = true
			dim.visible = true
		else:
			music.stream_paused = false
			get_tree().paused = false
			dim.visible = false
