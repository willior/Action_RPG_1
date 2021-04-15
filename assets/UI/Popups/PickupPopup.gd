extends Control

onready var text = $Label
onready var tween = $Tween
var pickupDisplay : String
var fade = Color(1, 1, 1, 0)

func _ready():
#	tween.interpolate_property(
#		text,
#		"rect_position",
#		Vector2(0,-8),
#		Vector2(0,0),
#		0.6,
#		Tween.TRANS_BOUNCE,
#		Tween.EASE_OUT
#		)
#	tween.start()
#	yield(tween, "tween_all_completed")
	text.set_text(pickupDisplay)
	tween.interpolate_property(
		text,
		"modulate",
		Color(1,1,1,1),
		fade,
		2.8,
		Tween.TRANS_QUINT,
		Tween.EASE_IN
		)
	tween.start()
	yield(tween, "tween_all_completed")
	queue_free()
