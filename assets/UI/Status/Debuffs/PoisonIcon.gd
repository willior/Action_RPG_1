extends TextureProgress

var status_nodepath
var duration

func _ready():
# warning-ignore:return_value_discarded
	get_node(status_nodepath).connect("poison_removed", self, "delete_status_progress")
	$AnimationPlayer.play("FadeIn")
	$Tween.interpolate_property(self, "value", 0, max_value, duration, Tween.TRANS_LINEAR)
	$Tween.start()

func delete_status_progress():
	queue_free()
