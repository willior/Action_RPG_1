extends ColorRect

func _ready():
	$Tween.interpolate_property(self,
	"modulate",
	Color(1, 1, 1, 0),
	Color(1, 1, 1, 1),
	0.3,
	Tween.TRANS_LINEAR,
	Tween.EASE_IN
	)
	$Tween.start()

func fade_out_greyscale():
	$Tween.interpolate_property(self,
	"modulate",
	Color(1, 1, 1, 1),
	Color(1, 1, 1, 0),
	0.3,
	Tween.TRANS_LINEAR,
	Tween.EASE_IN
	)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	queue_free()
