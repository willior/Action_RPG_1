extends Node2D

const BAT = preload("res://assets/Enemies/Bat.tscn")

onready var timer = $Timer

var count = 0

func _ready():
	
	spawner()

func spawner():
	if count > 20:
		return
	
	else:
		timer.start()
		yield(timer, "timeout")
		var batSpawn = BAT.instance()
		batSpawn.position = position
		get_node("/root/World/YSort").add_child(batSpawn)
		spawner()
		count += 1
