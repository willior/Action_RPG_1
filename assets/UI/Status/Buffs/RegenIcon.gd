extends TextureProgress

var duration

func _ready():
# warning-ignore:return_value_discarded
	get_node("/root/World/YSort/Player/Regen").connect("regen_removed", self, "delete_regen_progress")
	start_status_icon()

func start_status_icon():
	$AnimationPlayer.play("FadeIn")
	$Tween.interpolate_property(self, "value", 0, max_value, duration, Tween.TRANS_LINEAR)
	$Tween.start()

func refresh_status_icon():
	$AnimationPlayer.play("Flash")
	$Tween.interpolate_property(self, "value", 0, max_value, duration, Tween.TRANS_LINEAR)
	$Tween.start()

func delete_regen_progress():
	print('regen removed signal recieved; deleting regen icon')
	queue_free()
