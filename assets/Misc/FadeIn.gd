extends CanvasLayer

func _ready():
	$Sprite.show()
	Global.changingScene = false
	if Global.get_attribute("location") != null:
		get_node("/root/World/YSort/Player").position = Global.get_attribute("location")
	if Global.get_attribute("direction") != null:
		get_node("/root/World/YSort/Player").dir_vector = Global.get_attribute("direction")
		get_node("/root/World/YSort/Player").reset_animation()
	$Tween.interpolate_property($Sprite, "modulate",
			Color(1,1,1,1), Color(1,1,1,0), 0.4,
			Tween.TRANS_QUAD, Tween.EASE_IN
			)
	$Tween.interpolate_property(get_node("/root/World/SFX"), "volume_db",
			-48, 0, 0.8,
			Tween.TRANS_QUAD, Tween.EASE_IN_OUT
			)
	$Tween.interpolate_property(get_node("/root/World/SFX2"), "volume_db",
			-48, 0, 0.8,
			Tween.TRANS_QUAD, Tween.EASE_IN_OUT
			)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	get_parent().get_node("Music").play()
	queue_free()
