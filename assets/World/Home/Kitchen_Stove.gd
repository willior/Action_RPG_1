extends StaticBody2D

const DialogBox = preload("res://assets/UI/Dialog.tscn")

onready var player = get_node("/root/World/YSort/Player")

var interactable = false
var talkable = false
var examined = false
var index = 0

func _ready():
	if PlayerLog.home_stove_examined:
		examined = true
	
func examine():
	var dialogBox = DialogBox.instance()
	match index:
		0:
			index += 1
			dialogBox.dialog = [
			"It's your stove."
			]
		1:
			dialogBox.dialog = [
			"And oven!"
			]
			index = 0
			if !PlayerLog.home_stove_examined:
				PlayerLog.home_stove_examined = true
				examined = true
			
	get_node("/root/World/GUI").add_child(dialogBox)
