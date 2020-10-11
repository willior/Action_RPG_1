extends Area2D

var tutorialScene = preload("res://assets/Maps/1-1_Forest.tscn")

# monitoring for bodies on the Exits layer entering the area
func _on_Exit_body_entered(_body):
	print("exiting")
	var map_tutorial = tutorialScene.instance()
	# get_tree().get_root().add_child(map_tutorial)
	# get_node("/root/World").free()
	get_tree().change_scene("res://assets/Maps/1-1_Forest.tscn")
