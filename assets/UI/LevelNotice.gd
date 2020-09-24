extends Control

onready var timer = $Timer
onready var levelText = $VBoxContainer/LabelLevel
onready var statText = $VBoxContainer/LabelLevelStat

var levelDisplay
var statDisplay

# Define a format string with placeholder '%s'
var format_string = "%s UP"

# Using the '%' operator, the placeholder is replaced with the desired value
var actual_string = format_string % statDisplay

func _ready():
	print(actual_string)
	levelText.set_text("LEVEL " + str(levelDisplay) )
	statText.set_text(actual_string)
	# tween.interpolate_property(expText, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	# tween.start()
	print(statDisplay)
	print(str(statDisplay))
	# statText.set_text(statDisplay + " UP")
	
	
	timer.start()
	yield(timer, "timeout")
	queue_free()

func _process(delta):
	rect_position.y += 0.5
