extends Node2D

onready var timer = $Timer
onready var text = $Label
onready var tween = $Tween
onready var animation = $AnimationPlayer

var expDisplay

func _ready():
	text.set_text(str(expDisplay) + " XP")
	
	animation.play("Flash")
	
	# tween.interpolate_property(damageText, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	# tween.start()
	
	timer.start()
	yield(timer, "timeout")
	animation.stop()
		
	tween.interpolate_property(
		text,
		"modulate",
		Color(1, 0.65, 0, 1),
		Color(1, 0.65, 0, 0),
		1,
		Tween.TRANS_QUART,
		Tween.EASE_OUT
		)
#	tween.interpolate_property(
#		text,
#		"custom_colors/font_color_shadow",
#		Color(0,0,0,1),
#		Color(0,0,0,0),
#		1,
#		Tween.TRANS_QUART,
#		Tween.EASE_IN
#		)
	tween.start()
	yield(tween, "tween_all_completed")
	queue_free()

func _process(_delta):
	position.y -= 0.25
