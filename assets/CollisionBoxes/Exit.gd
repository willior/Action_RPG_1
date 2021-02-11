extends Area2D

export(String, FILE) var map_file
export var selected_location = Vector2()
var facing_direction = Vector2()

func _on_Exit_body_entered(_body):
	if _body.dying:
		return
		
	facing_direction = _body.dir_vector
	get_node("/root/World/").fade_out()
	$Timer.start()
	yield($Timer, "timeout")
	print('changing scene')
	# var new_inventory = _body.inventory
	# new_inventory array is created with 2 indexes: 0 references the inventory, 1 references the pouch
	var new_inventory = [get_node("/root/World/YSort/Player").inventory, get_node("/root/World/YSort/Player").pouch]
	Global.goto_scene(map_file, {"direction": facing_direction, "location":selected_location, "inventory":new_inventory})
