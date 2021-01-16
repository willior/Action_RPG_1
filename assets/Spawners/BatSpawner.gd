extends Node2D

#export var ENEMY = preload(Filepath)
export(PackedScene) var ENEMY
onready var pos = global_position

func _on_Area2D_area_entered(_area):
	var enemy = ENEMY.instance()
	get_parent().call_deferred("add_child", enemy)
	print('spawning: ', enemy.ENEMY_NAME)
	enemy.global_position = pos
	queue_free()
