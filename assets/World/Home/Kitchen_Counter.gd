extends StaticBody2D

const DialogBox = preload("res://assets/UI/DialogBox.tscn")
onready var sinkSprite = $Sprite/AnimatedSprite
onready var sinkAnim = $AnimationTree.get("parameters/playback")

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
	if PlayerLog.home_sink_examined:
		examined = true
	sinkSprite.play("OffComplete")
	$AnimationTree.active = true
	
func examine():
	var dialogBox = DialogBox.instance()
	match index:
		0:
			dialogBox.dialog_script = [
				{'text': "It's your sink."}
			]
			if !examined: examined = true
			if !examined_while_off: examined_while_off = true
		1:
			dialogBox.dialog_script = [
				{'text': "The faucet is working properly."}
			]
			if !examined: examined = true
			if !examined_while_on: examined_while_on = true
			
	if examined_while_off && examined_while_on && !PlayerLog.home_sink_examined:
		PlayerLog.home_sink_examined = true
		examined = true
			
	get_node("/root/World/GUI").add_child(dialogBox)

func interact():
	print('interacting with sink')
	if !is_on:
		sinkAnim.travel("Run")
		index = 1
		is_on = true
		if examined && !examined_while_on: examined = false
	else: 
		sinkAnim.travel("Off")
		index = 0
		is_on = false
		if !examined_while_off: examined = false

func use_item_on_object():
	var dialogBox = DialogBox.instance()
	if !is_on:
		dialogBox.dialog_script = [
				{'text': "You hold the Metal Pot under the faucet."},
				{'text': "Nothing happens."}
			]
	else:
		dialogBox.dialog_script = [
				{'text': "You hold the Metal Pot under the faucet."},
				{'text': "It fills with water!"}
			]

	get_node("/root/World/GUI").add_child(dialogBox)
