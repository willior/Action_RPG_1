extends StaticBody2D

const DialogBox = preload("res://assets/UI/Dialog.tscn")

onready var player = get_node("/root/World/YSort/Player")
onready var sink = $Sprite/AnimatedSprite

var interactable = true
var talkable = false
var examined = false
var examined_while_off = false
var examined_while_on = false
var index = 0

func _ready():
	if PlayerLog.home_sink_examined:
		examined = true
	sink.play("OffComplete")
	
func examine():
	var dialogBox = DialogBox.instance()
	match index:
		0:
			index += 1
			dialogBox.dialog = [
			"It's your sink."
			]
		1:
			dialogBox.dialog = [
			"The faucet is working properly."
			]
			index = 0
			if !PlayerLog.home_sink_examined:
				PlayerLog.home_sink_examined = true
				examined = true
			
	get_node("/root/World/GUI").add_child(dialogBox)

func interact():
	print('interacting with sink')
#	if !$Light2D.visible:
#		$AudioStreamPlayer.stream = load("res://assets/Audio/Lampswitch_On.wav")
#		$AudioStreamPlayer.play()
#		$Light2D.visible = true
#		PlayerLog.home_desk_on = true
#		index = 2
#		if examined && !examined_while_on: examined = false
#
#	elif $Light2D.visible:
#		$AudioStreamPlayer.stream = load("res://assets/Audio/Lampswitch_Off.wav")
#		$AudioStreamPlayer.play()
#		$Light2D.visible = false
#		PlayerLog.home_desk_on = false
#		index = 0
#		if !examined_while_off: examined = false


func _on_AnimatedSprite_animation_finished():
	pass # Replace with function body.
