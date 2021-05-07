extends TextureProgress

func _ready():
	var duration = max_value
# warning-ignore:return_value_discarded
	get_node("/root/World/YSort/Player/Poison").connect("poison_removed", self, "delete_poison_progress")
	$AnimationPlayer.play("FadeIn")
	$Tween.interpolate_property(self, "value", 0, max_value, duration, Tween.TRANS_LINEAR)
	$Tween.start()

func delete_poison_progress():
	print('poison removed signal recieved; deleting poison icon')
	queue_free()
