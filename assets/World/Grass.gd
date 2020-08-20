extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		var GrassEffect = load("res://assets/Effects/GrassEffect.tscn")
		var grassEffect = GrassEffect.instance() # creating a packed scene of GrassEffect, storing it inside of node grassEffect
		var world = get_tree().current_scene # getting the very first scene, in this case World
		world.add_child(grassEffect)
		queue_free()
