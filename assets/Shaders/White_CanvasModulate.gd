extends ColorRect

export var end_color : Color 

func _ready():
	flash()

func flash():
	$Tween.interpolate_property(
	self,
	"color",
	Color(1, 0, 0, 0.6),
	Color(1, 0, 0, 0.3),
	1,
	Tween.TRANS_LINEAR,
	Tween.EASE_IN
	)
	$Tween.start()
