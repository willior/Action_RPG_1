extends TextureProgress

func _ready():
	var duration = max_value
# warning-ignore:return_value_discarded
	get_node("/root/World/YSort/Player/Regen").connect("regen_removed", self, "delete_regen_progress")
	$AnimationPlayer.play("FadeIn")
	$Tween.interpolate_property(self, "value", 0, max_value, duration, Tween.TRANS_LINEAR)
	$Tween.start()

func delete_regen_progress():
	print('regen removed signal recieved; deleting regen icon')
	queue_free()
