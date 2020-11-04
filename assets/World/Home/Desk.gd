extends StaticBody2D

const DialogBox = preload("res://assets/UI/Dialog.tscn")

var interactable = true
var talkable = false
var examined = false
var examined_while_off = false
var examined_while_on = false
var index = 0

func _ready():
	if PlayerLog.home_desk_examined:
		examined = true
		examined_while_off = true
		examined_while_on = true
	if PlayerLog.home_desk_on:
		$Light2D.visible = true
		examined = false
		index = 4
	else:
		$Light2D.visible = false
	
func examine():
	var dialogBox = DialogBox.instance()
	match index:
		0:
			dialogBox.dialog = [
			"It's your desk.",
			"There's a library lamp sitting on top of it."
			]
			index = 1
		1:
			if PlayerLog.home_lightswitch_bedroom_on:
				dialogBox.dialog = [
				"The lamp is off."
				]
			else:
				dialogBox.dialog = [
				"It's too dark to see anything else."
				]
			index = 0
			if !examined: examined = true
			if !examined_while_off: examined_while_off = true
		2:
			dialogBox.dialog = [
			"There's nothing on the desk.",
			"Tidy and organized, as usual."
			]
			index = 3
		3:
			dialogBox.dialog = [
			"The warm glow of the lamp relaxes you."
			]
			index = 2
			if !examined: examined = true
			if !examined_while_on: examined_while_on = true
			if !examined_while_off: examined_while_off = true
			if !PlayerLog.home_desk_examined:
				PlayerLog.home_desk_examined = true
		4:
			dialogBox.dialog = [
			"Please try and remember to switch off the lights before leaving the house."
			]
			index = 2
			
	get_node("/root/World/GUI").add_child(dialogBox)
	
func interact():
	if !$Light2D.visible:
		$AudioStreamPlayer.stream = load("res://assets/Audio/Lampswitch_On.wav")
		$AudioStreamPlayer.play()
		$Light2D.visible = true
		PlayerLog.home_desk_on = true
		index = 2
		if examined && !examined_while_on: examined = false
		
	elif $Light2D.visible:
		$AudioStreamPlayer.stream = load("res://assets/Audio/Lampswitch_Off.wav")
		$AudioStreamPlayer.play()
		$Light2D.visible = false
		PlayerLog.home_desk_on = false
		index = 0
		if !examined_while_off: examined = false
