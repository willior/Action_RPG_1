extends TextureProgress

var duration
var advance_factor

func _ready():
	# if duration is 1, then the advance_factor should be 4
	# if duration is 2, then the advance_factor should be 2
	# if duration is 4, then the advance_factor should be 1
	# if duration is 8, then the advance_factor should be 0.5; step needs to be modified if less than 1
	advance_factor = 16 / (duration*4) # if input advances stun timer by 0.25s (b/a = 0.25)
# warning-ignore:return_value_discarded
	get_node("/root/World/YSort/Player/StatusDisplay/Stun").connect("stun_advanced", self, "advance_status_progress")
# warning-ignore:return_value_discarded
	get_node("/root/World/YSort/Player/StatusDisplay/Stun").connect("stun_removed", self, "delete_status_progress")
	$AnimationPlayer.play("FadeIn")
	$Tween.interpolate_property(self, "value", 0, max_value, duration, Tween.TRANS_LINEAR)
	$Tween.start()

func advance_status_progress(new_time):
	$Tween.stop(self, "value")
	self.value += advance_factor
	$Tween.interpolate_property(self, "value", value, max_value, new_time, Tween.TRANS_LINEAR)
	$Tween.start()

func delete_status_progress():
	queue_free()
