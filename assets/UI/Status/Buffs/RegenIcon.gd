extends TextureProgress

var status_nodepath
var duration

func _ready():
# warning-ignore:return_value_discarded
	get_node(status_nodepath).connect("regen_removed", self, "delete_status_progress")
	start_status_icon()

func start_status_icon():
	$AnimationPlayer.play("FadeIn")
	$Tween.interpolate_property(self, "value", 0, max_value, duration, Tween.TRANS_LINEAR)
	$Tween.start()

func refresh_status_icon(new_duration):
	$AnimationPlayer.play("Flash")
	$Tween.interpolate_property(self, "value", 0, max_value, new_duration, Tween.TRANS_LINEAR)
	$Tween.start()

func delete_status_progress():
	queue_free()
