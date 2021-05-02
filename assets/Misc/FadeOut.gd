extends CanvasLayer

func _ready():
	Global.changingScene = true
	get_tree().paused = true
	$Tween.interpolate_property($Black, "modulate",
			Color(0,0,0,0), Color(0,0,0,1), 0.8,
			Tween.TRANS_QUAD, Tween.EASE_IN
			)
	$Tween.interpolate_property(get_node("/root/World/SFX"), "volume_db",
			0, -48, 1.5,
			Tween.TRANS_QUAD, Tween.EASE_IN_OUT
			)
	$Tween.interpolate_property(get_node("/root/World/SFX2"), "volume_db",
			0, -48, 1.5,
			Tween.TRANS_QUAD, Tween.EASE_IN_OUT
			)
	$Tween.interpolate_property(get_node("/root/World/Music"), "volume_db",
			0, -48, 1.5,
			Tween.TRANS_QUAD, Tween.EASE_IN_OUT
			)
	$Tween.start()
