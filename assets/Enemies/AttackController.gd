extends Node2D

onready var start_position = global_position # start position for enemy
onready var target_position = global_position # where the enemy will travel to

onready var timer = $Timer

func update_target_position(vector):
	var target_vector = vector
	target_position = start_position + target_vector
	
func get_time_left():
	return timer.time_left # returns the time left on the timer
	
func start_attack_timer(duration):
	timer.start(duration)
