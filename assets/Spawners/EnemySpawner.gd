extends Node2D

#export var ENEMY = preload(Filepath)
export(PackedScene) var ENEMY
onready var pos = global_position
onready var z = z_index
var health : int

func _on_VisibilityNotifier2D_screen_entered():
	var enemy = ENEMY.instance()
	get_parent().call_deferred("add_child", enemy)
	enemy.global_position = pos
	enemy.z_index = z
	enemy.call_deferred("set_health", health)
	queue_free()
