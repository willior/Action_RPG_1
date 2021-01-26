extends CanvasLayer

func _ready():
	get_tree().paused = true
	$Tween.interpolate_property($Sprite, "modulate",
			Color(1,1,1,0), Color(1,1,1,1), 0.8,
			Tween.TRANS_QUAD, Tween.EASE_IN
			)
	$Tween.interpolate_property(get_node("/root/World/SFX"), "volume_db",
			0, -48, 1.6,
			Tween.TRANS_QUAD, Tween.EASE_IN_OUT
			)
	$Tween.interpolate_property(get_node("/root/World/SFX2"), "volume_db",
			0, -48, 1.6,
			Tween.TRANS_QUAD, Tween.EASE_IN_OUT
			)
	$Tween.interpolate_property(get_node("/root/World/Music"), "volume_db",
			0, -48, 1.6,
			Tween.TRANS_QUAD, Tween.EASE_IN_OUT
			)
	
	$Tween.start()
	yield($Tween, "tween_all_completed")
	print('fade-out completed')
