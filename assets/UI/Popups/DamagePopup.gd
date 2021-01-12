extends Node2D

onready var timer = $Timer
onready var text = $Label
onready var tween = $Tween
onready var animation = $AnimationPlayer

var is_crit
var is_miss

var red_fade = Color(1, 0.1, 0, 0)
var white_fade = Color(1, 1, 1, 0)
var fade

var damageDisplay

func _ready():
	
	if damageDisplay == "Miss!":
		fade = white_fade
	else:
		fade = red_fade
	if is_crit:
		animation.play("On")
		text.add_font_override("font", load("res://assets/Font/large_dynamicFont.tres"))
		damageDisplay = damageDisplay + "!"
		
	text.set_text(damageDisplay)
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
		fade,
		1,
		Tween.TRANS_QUART,
		Tween.EASE_IN
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
	timer.start()
	yield(timer, "timeout")
	queue_free()
