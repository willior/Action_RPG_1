extends StaticBody2D

const DialogBox = preload("res://assets/UI/Dialog.tscn")

onready var player = get_node("/root/World/YSort/Player")
onready var sinkSprite = $Sprite/AnimatedSprite
onready var sinkAnim = $AnimationTree.get("parameters/playback")
onready var sinkAudio = $AudioStreamPlayer

var runAudio = preload("res://assets/Audio/World/Home/Home_Sink_Audio.wav")

var interactable = true
var talkable = false
var examined = false
var examined_while_off = false
var examined_while_on = false
var index = 0
var sink_on = false

func _ready():
	if PlayerLog.home_sink_examined:
		examined = true
	sinkSprite.play("OffComplete")
	$AnimationTree.active = true
	
func examine():
	var dialogBox = DialogBox.instance()
	match index:
		0:
			dialogBox.dialog = [
			"It's your sink."
			]
			examined_while_off = true
		1:
			dialogBox.dialog = [
			"The faucet is working properly."
			]
			examined_while_on = true
			
	if examined_while_off && examined_while_on && !PlayerLog.home_sink_examined:
		PlayerLog.home_sink_examined = true
		examined = true
			
	get_node("/root/World/GUI").add_child(dialogBox)

func interact():
	print('interacting with sink')
	if !sink_on:
		sinkAnim.travel("Run")
		index = 1
		sink_on = true
		if examined && !examined_while_on: examined = false
	else: 
		sinkAnim.travel("Off")
		index = 0
		sink_on = false
		if !examined_while_off: examined = false
