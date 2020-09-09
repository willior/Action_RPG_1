extends Node2D

onready var dim = $GUI/Dim

func _process(delta):
		if Input.is_action_just_pressed("pause"):
			if get_tree().paused == false:
				get_tree().paused = true
				dim.visible = true
			else:
				get_tree().paused = false
				dim.visible = false
