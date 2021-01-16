extends Node2D

var BAT = preload("res://assets/Enemies/Bat.tscn")
onready var pos = global_position

func _on_Area2D_area_entered(_area):
	var bat = BAT.instance()
	get_parent().call_deferred("add_child", bat)
	print('spawning: ', bat.ENEMY_NAME)
	bat.global_position = pos
	queue_free()
