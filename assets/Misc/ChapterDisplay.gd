extends Node

var index = 0

func _on_Timer_timeout():
	if index == 0:
		$Chapter.visible = true
		index = 1
		$Timer.start(6.5)
	else:
		$Chapter.visible = false

func _on_AudioStreamPlayer_finished():
	Global.goto_scene("res://assets/Maps/0-1_Home.tscn")
