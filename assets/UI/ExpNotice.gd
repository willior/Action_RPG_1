extends Control

onready var timer = $Timer
onready var expText = $HBoxContainer/Label

var expDisplay

func _ready():
	expText.set_text(str(expDisplay) + " XP")
	timer.start()
	yield(timer, "timeout")
	queue_free()
