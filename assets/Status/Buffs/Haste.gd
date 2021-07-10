extends Node2D
var buff
const Icon = preload("res://assets/UI/Status/Buffs/HasteIcon.tscn")
var duration : float
var potency : float
onready var body = get_parent().get_parent()
signal haste_removed()

func _ready():
	body.hurtbox.display_damage_popup("Haste!", false, name)
	body.stats.speed_mod = potency
	if body.get("ENEMY_NAME"):
		pass
	else:
		if body.get_node("StatusDisplay").has_node("Slow"):
			print('haste overriding slow.')
			body.stats.attack_speed_penalty = 1.0
		body.animationTree.set("parameters/Run/TimeScale/scale", potency)
		var icon = Icon.instance()
		icon.duration = duration
		icon.status_nodepath = self.get_path()
		match body.name:
			"Player":
				get_node("/root/World/GUI/StatusDisplay1/StatusContainer/Buffs").add_child(icon)
			"Player2":
				get_node("/root/World/GUI/StatusDisplay2/StatusContainer/Buffs").add_child(icon)
	$Timer.start(duration)
	$AnimatedSprite.play()

func refresh_status(new_duration, new_potency):
	body.hurtbox.display_damage_popup("Haste", false, name)
	if body.get("ENEMY_NAME"):
		pass
	else:
		match body.name:
			"Player":
				get_node("/root/World/GUI/StatusDisplay1/StatusContainer/Buffs/HasteIcon").refresh_status_icon(new_duration)
			"Player2":
				get_node("/root/World/GUI/StatusDisplay2/StatusContainer/Buffs/HasteIcon").refresh_status_icon(new_duration)
	$Timer.start(new_duration)
	potency = new_potency

func _on_Timer_timeout():
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
