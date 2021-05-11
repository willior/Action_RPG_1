extends TextureProgress

var duration

func _ready():
# warning-ignore:return_value_discarded
	get_node("/root/World/YSort/Player/StatusDisplay/Poison").connect("poison_removed", self, "delete_status_progress")
	$AnimationPlayer.play("FadeIn")
	$Tween.interpolate_property(self, "value", 0, max_value, duration, Tween.TRANS_LINEAR)
	$Tween.start()

func delete_status_progress():
	queue_free()
