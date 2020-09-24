extends Control

onready var timer = $Timer
onready var levelText = $VBoxContainer/LabelLevel
onready var statText = $VBoxContainer/HBoxContainer/LabelLevelStat

var levelDisplay
var statDisplay
var statColor

func _ready():
	levelText.set_text("LEVEL " + str(levelDisplay) )
	statText.set_text(statDisplay)
	statText.add_color_override("font_color", statColor)
	# tween.interpolate_property(expText, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	# tween.start()
	timer.start()
	yield(timer, "timeout")
	queue_free()

func _process(delta):
	rect_position.y += 0.5
