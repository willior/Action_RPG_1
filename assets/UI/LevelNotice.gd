extends Control

onready var timer = $Timer
onready var levelText = $Label

var levelDisplay

func _ready():
	levelText.set_text("LEVEL " +str(levelDisplay) )
	
	# tween.interpolate_property(expText, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	# tween.start()
	
	timer.start()
	yield(timer, "timeout")
	queue_free()

func _process(delta):
	rect_position.y += 0.5
