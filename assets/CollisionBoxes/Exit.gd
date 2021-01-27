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
	var new_inventory = _body.inventory
	Global.goto_scene(map_file, {"direction": facing_direction, "location":selected_location, "inventory":new_inventory})
