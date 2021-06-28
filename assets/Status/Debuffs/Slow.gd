extends Node2D
var debuff
const Icon = preload("res://assets/UI/Status/Debuffs/SlowIcon.tscn")
var duration = 12 # number of ticks
var potency = 1
onready var body = get_parent().get_parent()
var old_speed
signal slow_removed()

func _ready():
	body.hurtbox.display_damage_popup("Slowed!", false, "Grey")
	if body.get("ENEMY_NAME"):
		pass
	else:
#		old_speed = body.stats.speed
#		body.stats.speed = int(old_speed/2)
#		body.stats.max_speed_mod = body.stats.max_speed/-2
		body.stats.speed_mod = 0.5
		body.animationTree.set("parameters/Run/TimeScale/scale", 0.5)
		var icon = Icon.instance()
		icon.duration = duration
		icon.status_nodepath = self.get_path()
		match body.name:
			"Player":
				get_node("/root/World/GUI/StatusDisplay1/StatusContainer/Debuffs").add_child(icon)
			"Player2":
				get_node("/root/World/GUI/StatusDisplay2/StatusContainer/Debuffs").add_child(icon)
	$Timer.start(duration)
	$AnimatedSprite.play()

func _on_Timer_timeout():
#	body.stats.speed = old_speed
#	body.stats.max_speed_mod = 0
	body.stats.speed_mod = 1
	body.animationTree.set("parameters/Run/TimeScale/scale", 1)
	queue_free()

func _on_SlowNotice_tree_exiting():
	if !$Timer.is_stopped():
#		body.stats.speed = old_speed
#		body.stats.max_speed_mod = 0
		body.stats.speed_mod = 1
		body.animationTree.set("parameters/Run/TimeScale/scale", 1)
	emit_signal("slow_removed")