extends Sprite

const DialogBox = preload("res://assets/UI/Dialog.tscn")

var interactable = true
var talkable = false
var examined = false
var unlitExamined = false
var litExamined = false
var index = 0
	
func examine():
	var dialogBox = DialogBox.instance()
	match index:
		0: # default dialog before the player turns the light on
			dialogBox.dialog = [
			"A switch of some kind."
			]
			if !examined: examined = true
			if !unlitExamined: unlitExamined = true
		1: # default dialog after the player turns the light on
			dialogBox.dialog = [
			"A switch for the bedroom light."
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
			if !litExamined: litExamined = true
		3: # dialog for 2nd examination while off
			dialogBox.dialog = [
			"It's in the 'OFF' position."
			]
			index -= 2
			if !examined: examined = true
			if !litExamined: litExamined = true
			
	get_node("/root/World/GUI").add_child(dialogBox)
	
func interact():
	if !$Light2D.visible:
		$Light2D.visible = true
		index = 1
		if examined && !litExamined: examined = false
		
	elif $Light2D.visible:
		$Light2D.visible = false
		index = 1
		if !unlitExamined: examined = false
