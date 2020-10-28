extends Area2D
export var selected_location = Vector2(160,168)
func _on_Exit_body_entered(_body):
	var new_inventory = _body.inventory
	Global.goto_scene("res://assets/Maps/0-1_Home.tscn", {"location":selected_location, "inventory":new_inventory})
