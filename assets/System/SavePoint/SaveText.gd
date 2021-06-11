extends Label

func _ready():
	$Tween.interpolate_property(self,
	"rect_position",
	Vector2(192, -27),
	Vector2(192, 120),
	1,
	Tween.TRANS_BOUNCE, Tween.EASE_OUT
	)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$Tween.interpolate_property(self,
#	"rect_position",
#	self.rect_position,
#	Vector2(192, 270),
	"modulate",
	Color(1,1,1,1),
	Color(1,1,1,0),
	1,
	Tween.TRANS_QUINT, Tween.EASE_IN
	)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	queue_free()
