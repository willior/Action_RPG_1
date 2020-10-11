extends Area2D
var selected_location = Vector2(160,168)
func _on_Exit_body_entered(_body):
	Global.goto_scene("res://assets/Maps/0-1_Home.tscn", {"location":selected_location})
