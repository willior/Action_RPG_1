extends Node

onready var newGameButton = $MarginContainer/VBoxContainer/NewGameButton
onready var continueButton = $MarginContainer/VBoxContainer/ContinueButton
onready var quitButton = $MarginContainer/VBoxContainer/QuitButton

func _ready():
	GameManager.on_title_screen = true
	newGameButton.grab_focus()
	var save_game = File.new()
	if not save_game.file_exists("res://Save/savegame.save"):
		print('menu: no save file, disabling Continue button')
		$MarginContainer/VBoxContainer/ContinueButton.disabled = true
	$Tween.interpolate_property($MarginContainer, "modulate", Color(0,0,0,0), Color(1,1,1,1), 1)
	$Tween.interpolate_property($ColorRect, "rect_position", Vector2(0,0), Vector2(-640,0), 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$Music.play()

func _input(event):
	if event.is_action_pressed("quit_game"):
		get_tree().quit()

func _on_NewGameButton_pressed():
	GameManager.new_game()

func _on_ContinueButton_pressed():
	GameManager.load_game()

func _on_QuitButton_pressed():
	get_tree().quit()
