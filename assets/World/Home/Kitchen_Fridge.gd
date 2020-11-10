extends StaticBody2D

const DialogBox = preload("res://assets/UI/DialogBox.tscn")

var interactable = true
var talkable = false
var examined = false
var examined_while_off = false
var examined_while_on = false
var index = 0

func _ready():
	if PlayerLog.home_fridge_examined:
		examined = true
		examined_while_off = true
		examined_while_on = true
	if PlayerLog.home_fridge_open:
		$Light2D.visible = true
		$Sprite.frame = 1
		index = 4
		examined = false
	elif !PlayerLog.home_fridge_open:
		$Light2D.visible = false
		$Sprite.frame = 0
	
func examine():
	var dialogBox = DialogBox.instance()
	match index:
		0: # default dialog before the player turns the light on
			dialogBox.dialog_script = [
				{'text': "Refrigerator..."}
			]
			if !examined: examined = true
			if !examined_while_off: examined_while_off = true
		1: # default dialog after the player turns the light on
			dialogBox.dialog_script = [
				{'text': "It's your fridge."}
			]
			# if the light is on, next dialog instanced index 2
			if $Light2D.visible: index = 2
			# if the light is off, next dialog instanced index 3
			elif !$Light2D.visible: index = 3
		2: # dialog for 2nd examination while on
			dialogBox.dialog_script = [
				{'text': "There is a single apple inside."}
			]
			index -= 1
			if !examined: examined = true
			if !examined_while_on: examined_while_on = true
			if !examined_while_off: examined_while_off = true
			if !PlayerLog.home_fridge_examined:
				PlayerLog.home_fridge_examined = true
		3: # dialog for 2nd examination while off
			dialogBox.dialog_script = [
				{'text': "It's running."}
			]
			index -= 2
			if !examined: examined = true
			if !examined_while_off: examined_while_off = true
		4:
			dialogBox.dialog_script = [
				{'text': "Looks like you forgot to close it."},
				{'text': "It's alright if these things slip your mind once in a while, but try not to make a habit of it."}
			]
			index -= 3
			if !examined: examined = true
		
	get_node("/root/World/GUI").add_child(dialogBox)
	
# function for switching the lights on and off
# after interacting, the dialog index always goes to 1
# checks if it's been examined in the opposite position
# if not, sets examined to false, which displays the "?!" notice
func interact():
	if !$Light2D.visible:
		$AudioStreamPlayer.stream = load("res://assets/Audio/Fridge_Open.wav")
		$AudioStreamPlayer.play()
		$Light2D.show()
		PlayerLog.home_fridge_open = true
		index = 1
		if examined && !examined_while_on: examined = false
		$Sprite.frame = 1
		
	elif $Light2D.visible:
		$AudioStreamPlayer.stream = load("res://assets/Audio/Fridge_Close.wav")
		$AudioStreamPlayer.play()
		$Light2D.hide()
		PlayerLog.home_fridge_open = false
		index = 1
		if !examined_while_off: examined = false
		$Sprite.frame = 0
