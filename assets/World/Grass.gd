extends Node2D

const GrassEffect = preload("res://assets/Effects/GrassEffect.tscn") # preload the scene and store it in a constant

func create_grass_effect():
	var grassEffect = GrassEffect.instance() # instance a packed scene of GrassEffect, storing it inside of its own variable, node grassEffect
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position # global_position is the position of Grass; sets the position of the grassEffect to the position of Grass

func _on_Hurtbox_area_entered(_area):
	create_grass_effect()
	queue_free()
