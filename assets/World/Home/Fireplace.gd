extends StaticBody2D

const DialogBox = preload("res://assets/UI/Dialog.tscn")

onready var player = get_node("/root/World/YSort/Player")

var interactable = false
var talkable = false
var examined = false
var index = 0

func _ready():
	if PlayerLog.home_fireplace_examined:
		examined = true

func examine():
	var dialogBox = DialogBox.instance()
	match index:
		0:
			index += 1
			dialogBox.dialog = [
			"It's a fireplace."
			]
		1:
			dialogBox.dialog = [
			"There is no fire."
			]
			index = 0
			if !PlayerLog.home_fireplace_examined:
				PlayerLog.home_fireplace_examined = true
				examined = true
			
	get_node("/root/World/GUI").add_child(dialogBox)
