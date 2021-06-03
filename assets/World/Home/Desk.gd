extends StaticBody2D

const DialogBox = preload("res://assets/UI/DialogBox.tscn")

var interactable = true
var talkable = false
var examined = false
var examined_while_off = false
var examined_while_on = false
var index = 0

func _ready():
	if name in PlayerLog.examined_list:
		examined = true
		examined_while_off = true
		examined_while_on = true
	if PlayerLog.home.desk_on:
		$Light2D.visible = true
		examined = false
		index = 4
	else:
		$Light2D.visible = false
	
func examine():
	var dialogBox = DialogBox.instance()
	match index:
		0:
			dialogBox.dialog_script = [
				{'text': "It's your desk."},
				{'text': "There's a library lamp sitting on top of it."}
			]
			index = 1
		1:
			if PlayerLog.home_lightswitch_bedroom_on:
				dialogBox.dialog_script = [
					{'text': "The lamp is off."}
				]
			else:
				dialogBox.dialog_script = [
					{'text': "It's too dark to see anything else."}
				]
			index = 0
			if !examined: examined = true
			if !examined_while_off: examined_while_off = true
		2:
			dialogBox.dialog_script = [
				{'text': "There's nothing on the desk."},
				{'text': "Tidy and organized, as usual."}
			]
			index = 3
		3:
			dialogBox.dialog_script = [
				{'text': "The warm glow of the lamp relaxes you."}
			]
			index = 2
			if !examined: examined = true
			if !examined_while_on: examined_while_on = true
			if !examined_while_off: examined_while_off = true
			PlayerLog.set_examined(name)
		4:
			dialogBox.dialog_script = [
				{'text': "Please try and remember to switch off the lights before leaving the house."}
			]
			index = 2
			
	get_node("/root/World/GUI").add_child(dialogBox)
	
func interact(_player):
	if !$Light2D.visible:
		$AudioStreamPlayer.stream = load("res://assets/Audio/Lampswitch_On.wav")
		$AudioStreamPlayer.play()
		$Light2D.visible = true
		PlayerLog.home.desk_on = true
		# PlayerLog.home_desk_on = true
		index = 2
		if examined && !examined_while_on: examined = false
		
	elif $Light2D.visible:
		$AudioStreamPlayer.stream = load("res://assets/Audio/Lampswitch_Off.wav")
		$AudioStreamPlayer.play()
		$Light2D.visible = false
		PlayerLog.home.desk_on = false
		index = 0
		if !examined_while_off: examined = false
