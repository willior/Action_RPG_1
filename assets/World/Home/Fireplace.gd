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
				{'text': "It's a fireplace."}
			]
		1:
			dialogBox.dialog_script = [
				{'text': "It's cold, and there's no wood anywhere."}
			]
			index = 0
			PlayerLog.set_examined(name)
			examined = true
	
	get_node("/root/World/GUI").add_child(dialogBox)
