extends Area2D

export(String, FILE) var map_file # = "res://assets/Maps/0-1_Home.tscn"
export var selected_location = Vector2() # = Vector2(160,168)

# Forest spawn: 272, 64

func _on_Exit_body_entered(_body):
	get_node("/root/World/").fade_out()
	$Timer.start()
	yield($Timer, "timeout")
	print('changing scene')
	
	var new_inventory = _body.inventory
	Global.goto_scene(map_file, {"location":selected_location, "inventory":new_inventory})
