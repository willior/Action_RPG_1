extends Node2D

onready var timer = $Timer
onready var tween = $Tween
onready var levelText = $VBoxContainer/LabelLevel
onready var statText = $VBoxContainer/HBoxContainer/LabelLevelStat
onready var player = get_tree().get_root().get_node("World/YSort/Player")

var levelDisplay
var statDisplay
var statColor

func _ready():
	var statColor_fade = statColor
	statColor_fade.a = 0
	levelText.set_text("LEVEL " + str(levelDisplay) )
	statText.set_text(statDisplay)
	statText.add_color_override("font_color", statColor)
#	tween.interpolate_property(
#		$VBoxContainer,
#		"rect_position",
#		Vector2(0,-16),
#		Vector2(0,0),
#		2,
#		Tween.TRANS_BOUNCE,
#		Tween.EASE_OUT
#		)
#	tween.start()
#	yield(tween, "tween_all_completed")
	timer.start()
	yield(timer, "timeout")
	tween.interpolate_property(
		levelText,
		"modulate",
		Color(1,1,1,1),
		Color(1,1,1,0),
		1,
		Tween.TRANS_QUART,
		Tween.EASE_IN
		)
	tween.interpolate_property(
		statText,
		"modulate",
		statColor,
		statColor_fade,
		1,
		Tween.TRANS_QUART,
		Tween.EASE_IN
		)
	tween.interpolate_property(
		$VBoxContainer/HBoxContainer/LabelUp,
		"modulate",
		Color(1,1,1,1),
		Color(1,1,1,0),
		1,
		Tween.TRANS_QUART,
		Tween.EASE_IN
		)
	tween.start()
	yield(tween, "tween_all_completed")
	queue_free()
	
func _process(_delta):
	global_position = player.global_position
