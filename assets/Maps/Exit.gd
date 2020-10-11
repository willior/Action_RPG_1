extends Area2D

# monitoring for bodies on the Exits layer entering the area
func _on_Exit_body_entered(_body):
	print("exiting")
