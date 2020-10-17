extends Sprite

const DialogBox = preload("res://assets/UI/Dialog.tscn")

var interactable = true
var talkable = false
var examined = false
var examined_while_off = false
var examined_while_on = false
var fullyExamined = false
var index = 0

func _ready():
	$Light2D.visible = false
	
func examine():
	var dialogBox = DialogBox.instance()
	match index:
		0: # default dialog before the player turns the light on
			dialogBox.dialog = [
			"A switch of some kind."
			]
			if !examined: examined = true
			if !examined_while_off: examined_while_off = true
		1: # default dialog after the player turns the light on
			dialogBox.dialog = [
			"A lightswitch."
			]
			# if the light is on, next dialog instanced index 2
			if $Light2D.visible: index = 2
			# if the light is off, next dialog instanced index 3
			elif !$Light2D.visible: index = 3
		2: # dialog for 2nd examination while on
			dialogBox.dialog = [
			"It's in the 'ON' position."
			]
			index -= 1
			if !examined: examined = true
			if !examined_while_on: examined_while_on = true
		3: # dialog for 2nd examination while off
			dialogBox.dialog = [
			"It's in the 'OFF' position."
			]
			index -= 2
			if !examined: examined = true
			if !examined_while_on: examined_while_on = true
			
	get_node("/root/World/GUI").add_child(dialogBox)
	
# function for switching the lights on and off
# after interacting, the dialog index always goes to 1
# checks if it's been examined in the opposite position
# if not, sets examined to false, which displays the "?!" notice
func interact():
	if !$Light2D.visible:
		$Light2D.show()
		index = 1
		if examined && !examined_while_on: examined = false
		frame = 1
		
	elif $Light2D.visible:
		$Light2D.hide()
		index = 1
		if !examined_while_off: examined = false
		frame = 0
