extends StaticBody2D

const DialogBox = preload("res://assets/UI/DialogBox.tscn")

var interactable = false
var talkable = false
var examined = false
var index = 0

func _ready():
	if PlayerLog.home_chair_examined:
		examined = true
	
func examine():
	var dialogBox = DialogBox.instance()
	match index:
		0:
			index += 1
			dialogBox.dialog_script = [
				{'text': "It's your old office chair."},
				{'text': "Not the most comfortable, but it's an antique."}
			]
		1:
			dialogBox.dialog_script = [
				{'text': "This is where you'd sit if you wanted to get any work done."}
			]
			index = 0
			if !PlayerLog.home_chair_examined:
				examined = true
				PlayerLog.home_chair_examined = true
			
	get_node("/root/World/GUI").add_child(dialogBox)
