extends ColorRect

export var start_color : Color
export var end_color : Color

func flash():
	$Tween.interpolate_property(
	self,
	"color",
	Color(0, 1, 1, 0),
	Color(0, 1, 1, 0.25),
	0.75,
	Tween.TRANS_QUART,
	Tween.EASE_IN
	)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$Tween.interpolate_property(
	self,
	"color",
	Color(0, 1, 1, 0.25),
	Color(0, 1, 1, 0),
	0.15,
	Tween.TRANS_LINEAR,
	Tween.EASE_OUT
	)
	$Tween.start()
