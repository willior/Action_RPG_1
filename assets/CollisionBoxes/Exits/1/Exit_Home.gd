extends Area2D

# monitoring for bodies on the Exits layer entering the area
func _on_Exit_body_entered(_body):
	print('zoning to 1-1 Forest')
	Global.goto_scene("res://assets/Maps/1-1_Forest.tscn")
