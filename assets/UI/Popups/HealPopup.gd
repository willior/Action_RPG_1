extends Control

onready var text = $Label
onready var tween = $Tween
var is_crit
var is_miss
var red_fade = Color(1, 0.1, 0, 0)
var white_fade = Color(1, 1, 1, 0)
var fade = Color(0, 1, 1, 0)
var damageDisplay

func _ready():
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
		Color(0,1,1,1),
		fade,
		1.4,
		Tween.TRANS_QUART,
		Tween.EASE_IN
		)
	tween.start()
	yield(tween, "tween_all_completed")
	queue_free()
