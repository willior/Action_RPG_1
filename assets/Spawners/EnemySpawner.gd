extends Node2D

export(PackedScene) var ENEMY
onready var pos = global_position
onready var z = z_index
var health : int

func _on_VisibilityNotifier2D_screen_entered():
	var enemy = load(ENEMY).instance()
	get_parent().call_deferred("add_child", enemy)
	enemy.global_position = pos
	enemy.z_index = z
	Enemy.call_deferred("set_health", enemy, health)
	queue_free()
