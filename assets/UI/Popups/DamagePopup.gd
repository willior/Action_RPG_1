extends Node2D

onready var timer = $Timer
onready var text = $Label
onready var tween = $Tween

var damageDisplay

func _ready():
	text.set_text(str(damageDisplay))
	tween.interpolate_property(
		text,
		"rect_position",
		Vector2(0,-8),
		Vector2(0,0),
		0.6,
		Tween.TRANS_BOUNCE,
		Tween.EASE_OUT
		)
	tween.start()
	
	yield(tween, "tween_all_completed")
	tween.interpolate_property(
		text,
		"modulate",
		Color(1,1,1,1),
		Color(0.8,0.2,0,0),
		1,
		Tween.TRANS_QUART,
		Tween.EASE_IN
		)
	tween.interpolate_property(
		text,
		"custom_colors/font_color_shadow",
		Color(0,0,0,1),
		Color(0,0,0,0),
		1,
		Tween.TRANS_QUART,
		Tween.EASE_IN
		)
	tween.start()
	timer.start()
	yield(timer, "timeout")
	queue_free()
