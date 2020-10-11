extends Area2D

var tutorialScene = preload("res://assets/Maps/1-1_Forest.tscn")
var world = "/root/Main/World"

# monitoring for bodies on the Exits layer entering the area
func _on_Exit_body_entered(_body):
	print("exiting")
	var map_tutorial = tutorialScene.instance()
	
	Global.goto_scene("res://assets/Maps/1-1_Forest.tscn")
	
	# warning-ignore:return_value_discarded
	# get_tree().change_scene("res://assets/Maps/1-1_Forest.tscn")
	
	# get_tree().change_scene_to(tutorialScene)
	#get_tree().get_root().call_deferred("add_child", map_tutorial)
	# get_tree().get_root().get_node("World").queue_free()

