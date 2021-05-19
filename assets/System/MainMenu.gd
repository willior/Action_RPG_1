extends Node

onready var newGameButton = $MarginContainer/VBoxContainer/NewGameButton
onready var continueButton = $MarginContainer/VBoxContainer/ContinueButton
onready var quitButton = $MarginContainer/VBoxContainer/QuitButton

func _ready():
	newGameButton.grab_focus()

func _on_NewGameButton_pressed():
	Global.goto_scene("res://assets/Maps/0_Prologue/0-1_Home.tscn")

func _on_ContinueButton_pressed():
	GameManager.load_game()

func _on_QuitButton_pressed():
	get_tree().quit()
