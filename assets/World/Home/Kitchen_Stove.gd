extends StaticBody2D

const DialogBox = preload("res://assets/UI/DialogBox.tscn")

var interactable = true
var talkable = false
var item_usable = true
var item_needed = "Metal_Pot"
var examined = false
var examined_while_off = false
var examined_while_on = false
var index = 0
var is_on = false

func _ready():
	if name in PlayerLog.examined_list:
		examined = true
	
func examine():
	var dialogBox = DialogBox.instance()
	match index:
		0:
			index += 1
			dialogBox.dialog_script = [
				{'text': "It's your stove."}
			]
		1:
			if !is_on:
				dialogBox.dialog_script = [
					{'text': "It's off."}
				]
				examined_while_off = true
			else:
				dialogBox.dialog_script = [
					{'text': "One of the burners is on."}
				]
				examined_while_on = true
			index = 0
			if examined_while_off && examined_while_on:
				PlayerLog.set_examined(name)
				examined = true
			
	get_node("/root/World/GUI").add_child(dialogBox)
	
func interact(_player):
	if !is_on:
		$AudioStreamPlayer.stream = load("res://assets/Audio/Fridge_Open.wav")
		$AudioStreamPlayer.play()
		$Light2D.visible = true
		is_on = true
		PlayerLog.home_stove_on = true
		if examined && !examined_while_on: examined = false
		$Sprite.frame = 1
		
	else:
		$AudioStreamPlayer.stream = load("res://assets/Audio/Fridge_Close.wav")
		$AudioStreamPlayer.play()
		$Light2D.visible = false
		is_on = false
		PlayerLog.home_stove_on = false
		if !examined_while_off: examined = false
		$Sprite.frame = 0
	
func use_item_on_object():
	var dialogBox = DialogBox.instance()
	if !is_on:
		dialogBox.dialog_script = [
				{'text': "You should try turning the stove on, first."}
			]
	else:
		dialogBox.dialog_script = [
				{'text': "You place the metal pot full of water onto the active burner."},
				{'text': "The water is beginning to boil!"}
			]
	get_node("/root/World/GUI").add_child(dialogBox)
