extends Control

onready var text = $Label
onready var tween = $Tween
var message : String
var fade = Color(1, 1, 1, 0)

func _ready():
	text.set_text(message)
	tween.interpolate_property(
		text,
		"modulate",
		Color(1,1,1,1),
		fade,
		4,
		Tween.TRANS_QUINT,
		Tween.EASE_IN
		)
	tween.start()
	yield(tween, "tween_all_completed")
	queue_free()
	
func level_flash():
	$AnimationPlayer.play('level_flash')
