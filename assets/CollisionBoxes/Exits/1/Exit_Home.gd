extends Area2D
# exit from the home to the forest

func _on_Exit_body_entered(_body):
	var new_inventory = _body.inventory
	Global.goto_scene("res://assets/Maps/1-1_Forest.tscn", {"inventory":new_inventory})
