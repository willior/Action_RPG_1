extends Control

onready var sprite = $Sprite
onready var timer = $Timer

var next_icon_modulator

func _ready():
	sprite.position.x = 280
	
func next_indicator_animate():
	pass

func _on_Timer_timeout():
	if sprite.position.x == 283:
		next_icon_modulator = -1
	elif sprite.position.x == 280:
		next_icon_modulator = 1
	sprite.position.x += next_icon_modulator
