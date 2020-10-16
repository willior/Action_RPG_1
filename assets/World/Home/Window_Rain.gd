extends AnimatedSprite

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
			"It's really coming down."
			]
		1:
			dialogBox.dialog = [
			"Doesn't look like it's going to stop any time soon."
			]
			index = 0
			if !examined: examined = true
			
	get_node("/root/World/GUI").add_child(dialogBox)
