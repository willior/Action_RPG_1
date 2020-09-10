extends Node2D

onready var dim = $GUI/Dim

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused == false:
			get_tree().paused = true
			dim.visible = true
		else:
			get_tree().paused = false
			dim.visible = false
			
	if Input.is_action_just_pressed("start"):
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
