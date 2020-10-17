extends StaticBody2D

const DialogBox = preload("res://assets/UI/Dialog.tscn")

var interactable = true
var talkable = false
var examined = false
var index = 0
	
func examine():
	var dialogBox = DialogBox.instance()
	match index:
		0:
			index += 1
			if !$Light2D.visible:
				dialogBox.dialog = [
				"It's your desk.",
				"There's a library lamp sitting on top of it."
				]
			elif $Light2D.visible:
				dialogBox.dialog = [
				"It's your desk.",
				"The warm glow of the lamp relaxes you."
				]
		1:
			dialogBox.dialog = [
			"Tidy and organized, as usual."
			]
			index = 0
			if !examined: examined = true
			
	get_node("/root/World/GUI").add_child(dialogBox)
	
func interact():
	print('interacting')
	if !$Light2D.visible:
		$Light2D.visible = true
		print('light on')
	elif $Light2D.visible:
		$Light2D.visible = false
		print('light off')