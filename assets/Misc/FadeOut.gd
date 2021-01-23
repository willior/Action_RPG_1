extends CanvasLayer

func _ready():
	$Tween.interpolate_property($Sprite, "modulate",
			Color(1,1,1,0), Color(1,1,1,1), 1,
			Tween.TRANS_QUAD, Tween.EASE_IN
			)
	$Tween.start()
	yield($Tween, "tween_all_completed")
