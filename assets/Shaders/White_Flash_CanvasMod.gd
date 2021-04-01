extends ColorRect

func flash():
	$Tween.interpolate_property(
	self,
	"color",
	Color(1, 1, 1, 1),
	Color(1, 1, 1, 0),
	0.1,
	Tween.TRANS_QUINT,
	Tween.EASE_IN
	)
	$Tween.start()
