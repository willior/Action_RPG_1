extends Node

onready var newGameButton = $MarginContainer/VBoxContainer/NewGameButton
onready var continueButton = $MarginContainer/VBoxContainer/ContinueButton
onready var quitButton = $MarginContainer/VBoxContainer/QuitButton

func _ready():
	newGameButton.grab_focus()

func _on_NewGameButton_pressed():
	pass # Replace with function body.

func _on_ContinueButton_pressed():
	pass # Replace with function body.

func _on_QuitButton_pressed():
	pass # Replace with function body.
