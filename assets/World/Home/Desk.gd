extends StaticBody2D

const DialogBox = preload("res://assets/UI/Dialog.tscn")

var interactable = true
var talkable = false
var examined = false
var unlitExamined = false
var lampExamined = false
var index = 0
	
func examine():
	var dialogBox = DialogBox.instance()
	match index:
		0:
			dialogBox.dialog = [
			"It's your desk.",
			"There's a library lamp sitting on top of it."
			]
			if !examined: examined = true
			if !unlitExamined: unlitExamined = true
		1:
			dialogBox.dialog = [
			"The warm glow of the lamp relaxes you."
			]
			index = 2
		2:
			dialogBox.dialog = [
			"There's nothing on the desk.",
			"Tidy and organized, as usual."
			]
			index -= 1
			if !examined: examined = true
			if !lampExamined: lampExamined = true
			
	get_node("/root/World/GUI").add_child(dialogBox)
	
func interact():
	if !$Light2D.visible:
		$AudioStreamPlayer.stream = load("res://assets/Audio/Lampswitch_On.wav")
		$AudioStreamPlayer.play()
		$Light2D.visible = true
		index = 1
		if examined && !lampExamined: examined = false
		
	elif $Light2D.visible:
		$AudioStreamPlayer.stream = load("res://assets/Audio/Lampswitch_Off.wav")
		$AudioStreamPlayer.play()
		$Light2D.visible = false
		index = 0
		if !unlitExamined: examined = false
