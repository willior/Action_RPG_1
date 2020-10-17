extends Node2D

var CROW = preload("res://assets/Enemies/Crow.tscn")
onready var pos = global_position

func _on_Area2D_area_entered(_area):
	var newCrow = CROW.instance()
	get_parent().call_deferred("add_child", newCrow)
	newCrow.global_position = pos
	queue_free()
