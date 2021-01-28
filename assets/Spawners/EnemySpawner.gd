extends Node2D

#export var ENEMY = preload(Filepath)
export(PackedScene) var ENEMY
onready var pos = global_position

func _on_VisibilityNotifier2D_screen_entered():
	var enemy = ENEMY.instance()
	get_parent().call_deferred("add_child", enemy)
	enemy.global_position = pos
	queue_free()
