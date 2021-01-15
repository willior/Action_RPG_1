extends Node2D

const BAT = preload("res://assets/Enemies/Bat.tscn")

onready var timer = $Timer
var enemies

var count = 0

func _ready():
	spawner()

func spawner():
	enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() > 16:
		print('max bat!')
		return
	
	elif count > 100:
		return
	
	else:
		timer.start()
		yield(timer, "timeout")
		var batSpawn = BAT.instance()
		batSpawn.position = position
		get_parent().add_child(batSpawn)
		spawner()
		count += 1
