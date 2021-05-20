extends Node

onready var newGameButton = $MarginContainer/VBoxContainer/NewGameButton
onready var continueButton = $MarginContainer/VBoxContainer/ContinueButton
onready var quitButton = $MarginContainer/VBoxContainer/QuitButton

func _ready():
	$Tween.interpolate_property($MarginContainer, "modulate", Color(0,0,0,0), Color(1,1,1,1), 1)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	newGameButton.grab_focus()
	$Music.play()

func _on_NewGameButton_pressed():
	GameManager.new_game()

func _on_ContinueButton_pressed():
	GameManager.load_game()

func _on_QuitButton_pressed():
	get_tree().quit()
