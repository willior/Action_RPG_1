extends StaticBody2D

const DialogBox = preload("res://assets/UI/Dialog.tscn")

onready var player = get_node("/root/World/YSort/Player")

var interactable = false
var talkable = false
var examined = false
var index = 0
	
func examine():
	var dialogBox = DialogBox.instance()
	match index:
		0:
			index += 1
			dialogBox.dialog = [
			"It's the bed that you sleep in every night."
			]
		1:
			dialogBox.dialog = [
			"Except tonight, of course."
			]
			index = 0
			if !examined: examined = true
			
	get_node("/root/World/GUI").add_child(dialogBox)
	player.talkTimer.start()