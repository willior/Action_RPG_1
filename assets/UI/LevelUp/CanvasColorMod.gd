extends ColorRect

var color_mod : Color
var duration : float

func _ready():
	$Tween.interpolate_property(self, "color", color_mod, Color(1, 1, 1, 0), duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	queue_free()
