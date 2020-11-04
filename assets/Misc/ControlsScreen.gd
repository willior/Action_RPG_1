extends Node

var ChapterScreen = load("res://assets/Misc/ChapterDisplay.tscn")

var ok_to_start = false

func _ready():
	GameManager.on_title_screen = true
	
func _input(event):
	if event.is_action_pressed("start") && ok_to_start:
		print('starting game')
		$ControlsDisplay.queue_free()
		var chapterScreen = ChapterScreen.instance()
		add_child(chapterScreen)
		ok_to_start = false
		
	if event.is_action_pressed("quit_game"):
		get_tree().quit()
		
func _on_Timer_timeout():
	$ControlsDisplay/StartMessage.visible = true
	$AudioStreamPlayer.play()
	ok_to_start = true
