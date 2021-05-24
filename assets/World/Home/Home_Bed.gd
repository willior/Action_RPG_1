extends StaticBody2D

const DialogBox = preload("res://assets/UI/DialogBox.tscn")

var interactable = false
var talkable = false
var examined = false
var index = 0

func _ready():
	if name in PlayerLog.examined_list:
		examined = true

func examine():
	var dialogBox = DialogBox.instance()
	match index:
		0:
			index += 1
			dialogBox.dialog_script = [
				{'text': "It's the bed that you sleep in every night."}
			]
		1:
			dialogBox.dialog_script = [
				{'text': "Except tonight, of course."}
			]
			index = 0
			PlayerLog.set_examined(name)
			examined = true
	
	get_node("/root/World/GUI").add_child(dialogBox)
