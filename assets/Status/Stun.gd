extends Node2D

onready var body = get_parent()

func _ready():
	print(body.name, ' is stunned!')
	body.hurtbox.display_damage_popup("Stunned!", false)
	body.state = 5
	Enemy.disable_detection(body)

func _on_Timer_timeout():
	print(body.name, ' recovered from stun.')
	body.state = 0
	Enemy.enable_detection(body)
	queue_free()
