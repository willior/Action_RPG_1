extends Node2D

onready var dim = $GUI/Dim
onready var timer = $Timer

const BAT = preload("res://assets/Enemies/Bat.tscn")

func spawner():
	timer.start()
	yield(timer, "timeout")
	var batSpawn = BAT.instance()
	batSpawn.global_position.x = 72
	batSpawn.global_position.y = 120
	get_node("/root/World/YSort").add_child(batSpawn)
	spawner()

func _ready():
	spawner()

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
			print('start pressed in dialog')
		if PlayerStats.health <= 0:
			get_tree().paused = false
			get_node("/root/World/GUI/GameOver").queue_free()
			get_node("/root/World/GUI/HealthUI").visible = true
			get_node("/root/World/GUI/ExpBar").visible = true
			get_node("/root/World/GUI/StaminaBar").visible = true
			get_node("/root/World/YSort/Player").visible = true
			PlayerStats.health += 1
			PlayerStats.continue_count += 1
			PlayerStats.experience -= (PlayerStats.experience_required / 10)
			
		elif get_tree().paused == false:
			get_tree().paused = true
			dim.visible = true
		else:
			get_tree().paused = false
			dim.visible = false
