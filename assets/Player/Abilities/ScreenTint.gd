extends ColorRect

export var start_color : Color
export var end_color : Color

func flash():
	$Tween.interpolate_property(
	self,
	"color",
	start_color,
	end_color,
	0.75,
	Tween.TRANS_QUART,
	Tween.EASE_IN
	)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$Tween.interpolate_property(
	self,
	"color",
	end_color,
	start_color,
	0.15,
	Tween.TRANS_LINEAR,
	Tween.EASE_OUT
	)
	$Tween.start()
