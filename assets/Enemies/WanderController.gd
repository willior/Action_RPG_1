extends Node2D

export(int) var wander_range = 32 # reusable variable declaring the distance the enemy will wander

onready var start_position = global_position # start position for enemy
onready var target_position = global_position # where the enemy will travel to

func update_target_position():
	var target_vector = Vector2(rand_range(-wander_range, wander_range), rand_range(-wander_range, wander_range))
	target_position = start_position + target_vector # setting the target position RELATIVE to the start position

func _on_Timer_timeout(): # every time the timer goes off, picks a new position to wander to
	update_target_position()
