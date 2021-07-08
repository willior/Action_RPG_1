extends Node2D
var buff
# const Icon = preload("res://assets/UI/Status/Debuffs/HasteIcon.tscn")
var duration = 12 # number of ticks
var potency = 1
onready var body = get_parent().get_parent()
signal haste_removed()

func _ready():
	body.hurtbox.display_damage_popup("Haste!", false, name)
	body.stats.speed_mod = 1.5
	print(body.name, " speed_mod = ", body.stats.speed_mod)
	if body.get("ENEMY_NAME"):
		pass
	else:
		body.animationTree.set("parameters/Run/TimeScale/scale", 1.5)
#		var icon = Icon.instance()
#		icon.duration = duration
#		icon.status_nodepath = self.get_path()
#		match body.name:
#			"Player":
#				get_node("/root/World/GUI/StatusDisplay1/StatusContainer/Debuffs").add_child(icon)
#			"Player2":
#				get_node("/root/World/GUI/StatusDisplay2/StatusContainer/Debuffs").add_child(icon)
	$Timer.start(duration)
	$AnimatedSprite.play()

func _on_Timer_timeout():
	if body.get_node("StatusDisplay").has_node("Slow"):
		queue_free()
	else:
		body.stats.speed_mod = 1
		if body.get("ENEMY_NAME"):
			pass
		else:
			body.animationTree.set("parameters/Run/TimeScale/scale", 1)
		queue_free()

func _on_HasteNotice_tree_exiting():
	if !$Timer.is_stopped() and !body.get_node("StatusDisplay").has_node("Slow"):
		body.stats.speed_mod = 1
		if body.get("ENEMY_NAME"):
			pass
		else:
			body.animationTree.set("parameters/Run/TimeScale/scale", 1)
	emit_signal("haste_removed")
