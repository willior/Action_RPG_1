extends StaticBody2D

const DialogBox = preload("res://assets/UI/DialogBox.tscn")
onready var player = get_node("/root/World/YSort/Player")

var interactable = false
var talkable = false
var examined = false
var index = 0

func _ready():
	if PlayerLog.home_bookshelf_examined:
		examined = true
	
func examine():
	var dialogBox = DialogBox.instance()
	match index:
		0:
			index += 1
			dialogBox.dialog_script = [
				{'text': "It's your bookshelf."}
			]
		1:
			dialogBox.dialog_script = [
				{'text': "There are a lot of old psychology books here."}
			]
			index = 0
			if !PlayerLog.home_bookshelf_examined:
				PlayerLog.home_bookshelf_examined = true
				examined = true
			
	get_node("/root/World/GUI").add_child(dialogBox)
