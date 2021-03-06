extends StaticBody2D

const ItemCollectEffect = preload("res://assets/Effects/ItemCollectEffect.tscn")
const DialogBox = preload("res://assets/UI/DialogBox.tscn")
const on_SFX = preload("res://assets/Audio/World/Home/Home_Sink_On.wav")
const run_SFX = preload("res://assets/Audio/World/Home/Home_Sink_Audio.wav")
const off_SFX = preload("res://assets/Audio/World/Home/Home_Sink_Off.wav")
onready var sinkSprite = $Sprite/AnimatedSprite
onready var sinkAnim = $AnimationTree.get("parameters/playback")

var interactable = true
var talkable = false
var item_usable = true
var item_needed = "Metal Pot"
var examined = false
var examined_while_off = false
var examined_while_on = false
var index = 0
var is_on = false

func _ready():
	if name in PlayerLog.examined_list:
		examined = true
	if PlayerLog.home.sink_on:
		sinkAnim.travel("Run")
		index = 1
		is_on = true
	else:
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
			
	if examined_while_off && examined_while_on:
		PlayerLog.set_examined(name)
		examined = true
			
	get_node("/root/World/GUI").add_child(dialogBox)

func interact(_player):
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
	PlayerLog.home.sink_on = is_on

func use_item_on_object():
	var dialogBox = DialogBox.instance()
	dialogBox.dialog_object_path = get_path()
	if !is_on:
		dialogBox.dialog_script = [
				{'text': "You hold the Metal Pot under the faucet."},
				{'text': "Nothing happens."}
			]
	else:
		dialogBox.dialog_script = [
				{'text': "You hold the Metal Pot under the faucet."},
				{'text': "It fills with water!",
				'action': 'take_item',
				'skip': '0'
				}
			]
		# GameManager.player.inventory.remove_item("Metal Pot", 1)
		# PlayerLog.metal_pot_water_collected = true

	get_node("/root/World/GUI").add_child(dialogBox)
	
func acquire_item():
	var itemCollectEffect = ItemCollectEffect.instance()
	get_parent().add_child(itemCollectEffect)
	itemCollectEffect.playSound(1)
#	GameManager.player.inventory.add_item("Metal Pot (Water)", 1)
#	PlayerLog.metal_pot_collected = true
#	queue_free()

func load_and_play(SFX):
	match SFX:
		"on":
			$AudioStreamPlayer.stream = on_SFX
		"run":
			$AudioStreamPlayer.stream = run_SFX
		"off":
			$AudioStreamPlayer.stream = off_SFX
	$AudioStreamPlayer.play()
