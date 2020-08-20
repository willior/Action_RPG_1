extends Node2D

func create_grass_effect():

	var GrassEffect = load("res://assets/Effects/GrassEffect.tscn") # load the scene and store it in a variable
	var grassEffect = GrassEffect.instance() # instance a packed scene of GrassEffect, storing it inside of its own variable, node grassEffect
	var world = get_tree().current_scene # getting the very first scene, in this case World
	world.add_child(grassEffect) # adding the grassEffect scene to the World scene
	grassEffect.global_position = global_position # global_position is the position of Grass; sets the position of the grassEffect to the position of Grass

func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
