extends TextureProgress

func _ready():
# warning-ignore:return_value_discarded
	get_node("/root/World/YSort/Player/Poison").connect("poison_progress_updated", self, "update_poison_progress")
	$AnimationPlayer.play("FadeIn")

func update_poison_progress(count):
	self.value = count
	print(value, "/", max_value)
	if value >= max_value:
		queue_free()
		# $AnimationPlayer.play("FadeOut")

func delete_poison_progress():
	queue_free()
