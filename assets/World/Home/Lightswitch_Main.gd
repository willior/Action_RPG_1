extends Sprite

# if neither switch has been switched on, examining either one will produce
# the message "A switch of some kind". both will give the examine notice. on
# first examine, the examine notice will disappear for both lights. this is
# the only dialog before turning either of the switches on.
# when a light is turned on, the notice comes back for both switches,
# indicating new dialog. the first line for both on & off positions is
# "A lightswitch." if a lightswitch is examined a second time, a message will
# display whether it is in the 'ON' or 'OFF' position. the game keeps track
# of whether a lightswitch state has been fully examined, and uses the examined
# status of both states to determine whether to display the notice or not.
# for the examine notice to permanently disappear, one must see both the 'ON'
# and 'OFF' dialog boxes. otherwise, toggling either switch, regardless if
# its new state has been examined or not, will re-instantiate the examine
# notice for both switches. seeing both 'ON' and 'OFF' dialog for either
# switch will turn off the examine permanently notice for both.

const DialogBox = preload("res://assets/UI/Dialog.tscn")

var interactable = true
var talkable = false
var examined = false
var examined_while_off = false
var examined_while_on = false
var index = 0

func _ready():
	if PlayerLog.home_lightswitch_checked:
		index = 1
	if PlayerLog.home_lightswitch_examined:
		# index = 1
		examined = true
		examined_while_off = true
		examined_while_on = true
		
	if PlayerLog.home_lightswitch_main_on:
		$Light2D.visible = true
		index = 4
	else:
		$Light2D.visible = false
		
# warning-ignore:return_value_discarded
	PlayerLog.connect("home_lightswitch_complete", self, "examine_complete")
# warning-ignore:return_value_discarded
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
			"It's in the 'ON' position.",
			"Remember to switch the lights off before you leave."
			]
			index = 1
			if !examined:
				examined = true
				# PlayerLog.set_examined("home_lightswitch", true)
			if !examined_while_on:
				get_parent().lightswitch_examined_while_on = true
		
		3: # dialog for 2nd examination while off
			dialogBox.dialog = [
			"It's in the 'OFF' position.",
			"Thank you for saving energy."
			]
			index = 1
			if !examined:
				examined = true
				# PlayerLog.set_examined("home_lightswitch", true)
			if !examined_while_off:	
				get_parent().lightswitch_examined_while_off = true
		4:
			dialogBox.dialog = [
			"Please try and remember to switch off the lights before leaving the house."
			]
			index = 1
	
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
		PlayerLog.home_lightswitch_main_on = true
		PlayerLog.set_dialog_index("home_lightswitch", 1)
		if !PlayerLog.home_lightswitch_checked:
			PlayerLog.home_lightswitch_checked = true
		if examined && !get_parent().lightswitch_examined_while_on:
			examined = false
		if !PlayerLog.home_lightswitch_examined:
			PlayerLog.set_examined("home_lightswitch", false)
		frame = 1
		
	elif $Light2D.visible: # turn off light
		$AudioStreamPlayer.stream = load("res://assets/Audio/Lightswitch_Off.wav")
		$AudioStreamPlayer.play()
		$Light2D.hide()
		PlayerLog.home_lightswitch_main_on = false
		index = 1
		if examined && !get_parent().lightswitch_examined_while_off && !PlayerLog.home_lightswitch_examined:
			examined = false
		frame = 0
		
func examine_complete(value):
	examined = value

func advance_dialog_index(value):
	index = value
