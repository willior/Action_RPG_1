extends Control

onready var timer = $Timer
onready var expText = $Label
onready var tween = $Tween

var expDisplay

func _ready():
	expText.set_text(str(expDisplay) + " XP")
	
	# tween.interpolate_property(expText, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	# tween.start()
	
	timer.start()
	yield(timer, "timeout")
	queue_free()

func _process(_delta):
	rect_position.y -= 0.25
