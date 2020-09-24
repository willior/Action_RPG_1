extends Node2D

const BAT = preload("res://assets/Enemies/Bat.tscn")

onready var timer = $Timer

var count = 0

func _ready():
	
	spawner()

func spawner():
	if count > 100:
		return
	
	else:
		timer.start(0.5)
		yield(timer, "timeout")
		var batSpawn = BAT.instance()
		batSpawn.position = position
		get_node("/root/World/YSort").add_child(batSpawn)
		spawner()
		count += 1
