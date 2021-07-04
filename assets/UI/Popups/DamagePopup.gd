extends Control

onready var text = $Label
onready var tween = $Tween

var is_crit : bool
var is_miss : bool
var mod
var kind
var popup_color = Color(1, 1, 1, 1)
var red_fade = Color(1, 0.1, 0, 0)
var teal_fade = Color(0, 1, 1, 0)
var white_fade = Color(1, 1, 1, 0)
var fade
var damageDisplay

func _ready():
	match kind:
		"Normal":
			fade = red_fade
		"Slow":
			popup_color = Color(0.6, 0.6, 0.6, 1)
			fade = red_fade
		"Poison":
			popup_color = Color(0.5, 0, 1, 1)
			fade = red_fade
		"Red":
			popup_color = Color(1, 0, 0, 1)
			fade = red_fade
		"Stun":
			popup_color = Color(1, 1, 0, 1)
			fade = red_fade
		"Heal":
			popup_color = Color(0, 1, 1, 1)
			fade = teal_fade
	if damageDisplay == "Miss!":
		fade = white_fade
	if is_crit:
		$AnimationPlayer.play("crit_flash")
		text.add_font_override("font", load("res://assets/Font/large_dynamicFont.tres"))
		rect_min_size.y = 6
		damageDisplay = damageDisplay + "!"
		visible = false
		call_deferred("set_visible", true)
	text.modulate = popup_color
	text.set_text(damageDisplay)
	match mod:
		0: # mod to white / resisted
			tween.interpolate_property(
				text,
				"modulate",
				popup_color,
				Color(1, 1, 1, 1),
				0.6,
				Tween.TRANS_QUAD,
				Tween.EASE_IN
			)
			fade = white_fade
		1: # mod to teal / Cleansed
			tween.interpolate_property(
				text,
				"modulate",
				popup_color,
				Color(0, 1, 1, 1),
				0.6,
				Tween.TRANS_QUAD,
				Tween.EASE_IN
			)
			fade = teal_fade
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
		text.modulate,
		fade,
		1.4,
		Tween.TRANS_QUART,
		Tween.EASE_IN
		)
	tween.start()
	yield(tween, "tween_all_completed")
	queue_free()
