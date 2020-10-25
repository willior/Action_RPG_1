extends Sprite

const DialogBox = preload("res://assets/UI/Dialog.tscn")

var interactable = true
var talkable = false
var examined = false
var examined_while_off = false
var examined_while_on = false
var index = 0

func _ready():
	$Light2D.visible = false
	PlayerLog.connect("home_lightswitch_complete", self, "examine_complete")
	PlayerLog.connect("home_lightswitch_advance", self, "advance_dialog_index")
	
func examine():
	var dialogBox = DialogBox.instance()
	match index:
		0: # default dialog before the player turns the light on
			dialogBox.dialog = [
			"A switch of some kind."
			]
			if !examined:
				PlayerLog.set_examined("home_lightswitch", true)
		
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
			index = 1
			if !examined:
				examined = true
				# PlayerLog.set_examined("home_lightswitch", true)
			if !examined_while_on:
					get_parent().lightswitch_examined_while_on = true
		
		3: # dialog for 2nd examination while off
			dialogBox.dialog = [
			"It's in the 'OFF' position."
			]
			index = 1
			if !examined:
				examined = true
				# PlayerLog.set_examined("home_lightswitch", true)
			if !examined_while_off:	
				get_parent().lightswitch_examined_while_off = true
	
	if get_parent().lightswitch_examined_while_off && get_parent().lightswitch_examined_while_on && !PlayerLog.home_lightswitch_examined:
		PlayerLog.home_lightswitch_examined = true
		PlayerLog.set_examined("home_lightswitch", true)
		
	get_node("/root/World/GUI").add_child(dialogBox)
	
# function for switching the lights on and off
# after interacting, the dialog index always goes to 1
# checks if it's been examined in the opposite position
# if not, sets examined to false, which displays the "?!" notice
func interact():
	if !$Light2D.visible: # turn on light
		$AudioStreamPlayer.stream = load("res://assets/Audio/Lightswitch_On.wav")
		$AudioStreamPlayer.play()
		$Light2D.show()
		PlayerLog.set_dialog_index("home_lightswitch", 1)
		if examined && !get_parent().lightswitch_examined_while_on:
			examined = false
		if !PlayerLog.home_lightswitch_examined:
			PlayerLog.set_examined("home_lightswitch", false)
		frame = 1
		
	elif $Light2D.visible: # turn off light
		$AudioStreamPlayer.stream = load("res://assets/Audio/Lightswitch_Off.wav")
		$AudioStreamPlayer.play()
		$Light2D.hide()
		index = 1
		if examined && !get_parent().lightswitch_examined_while_off && !PlayerLog.home_lightswitch_examined:
			examined = false
		frame = 0
		
func examine_complete(value):
	examined = value

func advance_dialog_index(value):
	index = value
