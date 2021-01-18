extends Node

var ChapterScreen = load("res://assets/Misc/ChapterDisplay.tscn")

var ok_to_start = false

func _ready():
	GameManager.on_title_screen = true
	
func _input(event):
	if event.is_action_pressed("start") && ok_to_start:
		$ControlsDisplay.queue_free()
#		var chapterScreen = ChapterScreen.instance()
#		chapterScreen.SCENE_STRING = "res://assets/Maps/0-1_Home.tscn"
#		add_child(chapterScreen)
		ok_to_start = false
		Global.goto_scene("res://assets/Maps/0-1_Home/0-1_Home_NEW.tscn")
		
	if event.is_action_pressed("quit_game"):
		get_tree().quit()
		
func _on_Timer_timeout():
	$ControlsDisplay/StartMessage.visible = true
	$AudioStreamPlayer.play()
	ok_to_start = true
