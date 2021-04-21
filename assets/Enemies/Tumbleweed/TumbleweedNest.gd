extends Node2D

const TUMBLEWEED = preload("res://assets/Enemies/Tumbleweed/Tumbleweed.tscn")
onready var player = get_parent().get_parent().get_node("Player")
onready var map = get_parent().get_parent().get_parent().get_node("Map")
onready var timer = $Timer
var enemies
var max_spawn_time = 5
var min_spawn_time = 0.5
var count = 0

func _ready():
	spawner()

func spawner():
	enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() > 20:
		print('max tumbleweed!')
		return
	
	if count > 100:
		return
	
	else:
		timer.start(rand_range(min_spawn_time, max_spawn_time))
		yield(timer, "timeout")
		var tumbleweedSpawn = TUMBLEWEED.instance()
		# tumbleweeds spawn 1 screen to the right of the player
		# y-position is modulated by half of the player's Y-velocity
		if map.wind_direction == "left":
			tumbleweedSpawn.position = player.position + Vector2(320, rand_range(0, player.velocity.y/2))
		elif map.wind_direction == "right":
			tumbleweedSpawn.position = player.position + Vector2(-320, rand_range(0, player.velocity.y/2))

		get_parent().add_child(tumbleweedSpawn)
		if tumbleweedSpawn.global_position.x < -6:
			tumbleweedSpawn.global_position.x = -6
		elif tumbleweedSpawn.global_position.x > 4122:
			tumbleweedSpawn.global_position.x = 4122
		spawner()
		count += 1
