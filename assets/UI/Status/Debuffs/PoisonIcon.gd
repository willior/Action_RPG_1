extends TextureProgress

var duration

func _ready():
	self.max_value = duration
# warning-ignore:return_value_discarded
	get_node("/root/World/YSort/Player/Stun").connect("stun_removed", self, "delete_stun_progress")
	$AnimationPlayer.play("FadeIn")
	$Tween.interpolate_property(self, "value", 0, max_value, duration, Tween.TRANS_LINEAR)
	$Tween.start()

func delete_stun_progress():
	print('stun removed signal received; deleting stun icon')
	queue_free()
