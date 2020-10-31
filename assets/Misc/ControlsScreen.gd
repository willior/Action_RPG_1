extends Node

onready var charge_bar_1 = $ChargeUI/TextureProgress1
onready var charge_bar_2 = $ChargeUI/TextureProgress2

var ok_to_start = false

func _ready():
	GameManager.on_title_screen = true

func _process(delta):
	pass
	
func _input(event):
	if event.is_action_pressed("start") && ok_to_start:
		print('starting game')
