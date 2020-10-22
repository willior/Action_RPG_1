extends Node2D

const BAT = preload("res://assets/Enemies/Bat.tscn")

onready var timer = $Timer
var enemies

var count = 0

func _ready():
	pass
	# spawner()

func spawner():
	enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() > 20:
		print('max bat!')
		return
	
	if count > 100:
		return
	
	else:
		timer.start(0.5)
		yield(timer, "timeout")
		var batSpawn = BAT.instance()
		batSpawn.position = position
		get_parent().add_child(batSpawn)
		spawner()
		count += 1
