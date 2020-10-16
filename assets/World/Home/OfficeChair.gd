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
			"It's your old office chair.",
			"Not the most comfortable, but it's an antique."
			]
		1:
			dialogBox.dialog = [
			"This is where you'd sit if you wanted to get any work done."
			]
			index = 0
			if !examined: examined = true
			
	get_node("/root/World/GUI").add_child(dialogBox)
