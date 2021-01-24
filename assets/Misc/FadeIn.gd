extends CanvasLayer

onready var sfx = get_node("/root/World/SFX")

func _ready():
	get_tree().paused = true
	if Global.get_attribute("location") != null:
		get_node("/root/World/YSort/Player").position = Global.get_attribute("location")
	
	$Tween.interpolate_property($Sprite, "modulate",
			Color(1,1,1,1), Color(1,1,1,0), 1,
			Tween.TRANS_QUAD, Tween.EASE_IN
			)
	$Tween.interpolate_property(get_node("/root/World/SFX"), "volume_db",
			-48, 0, 1,
			Tween.TRANS_QUAD, Tween.EASE_IN_OUT
			)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	get_tree().paused = false
	get_parent().get_node("Music").play()
	queue_free()
