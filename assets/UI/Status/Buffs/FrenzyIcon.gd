extends TextureProgress

var duration

func _ready():
# warning-ignore:return_value_discarded
	get_node("/root/World/YSort/Player/Frenzy").connect("frenzy_removed", self, "delete_frenzy_progress")
	start_status_icon()

func start_status_icon():
	$AnimationPlayer.play("FadeIn")
	$Tween.interpolate_property(self, "value", 0, max_value, duration, Tween.TRANS_LINEAR)
	$Tween.start()

func refresh_status_icon():
	$AnimationPlayer.play("Flash")
	$Tween.interpolate_property(self, "value", 0, max_value, duration, Tween.TRANS_LINEAR)
	$Tween.start()

func delete_frenzy_progress():
	print('frenzy removed signal received; deleting frenzy icon')
	queue_free()
