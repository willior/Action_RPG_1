extends Node2D
var buff
const Icon = preload("res://assets/UI/Status/Buffs/FrenzyIcon.tscn")
var duration
var potency
onready var body = get_parent().get_parent()
signal frenzy_removed()

func _ready():
	body.hurtbox.display_damage_popup("Frenzy", false, "Red")
	if body.get("ENEMY_NAME"):
		pass
	else:
		# body.set_attack_timescale(body.stats.attack_speed * potency)
		body.stats.attack_speed_mod = 1.0 * potency
		body.set_stamina_attack_cost(body.stats.stamina_attack_cost / 5)
		body.knockback_modifier = 0.2
		
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
	body.hurtbox.display_damage_popup("Frenzy", false, "Red")
	if body.get("ENEMY_NAME"):
		pass
	else:
		# body.set_attack_timescale(body.stats.attack_speed * new_potency)
		body.stats.attack_speed_mod = 1.0 * new_potency
		body.set_stamina_attack_cost(body.stats.stamina_attack_cost / 5)
		
		match body.name:
			"Player":
				get_node("/root/World/GUI/StatusDisplay1/StatusContainer/Buffs/FrenzyIcon").refresh_status_icon(new_duration)
			"Player2":
				get_node("/root/World/GUI/StatusDisplay2/StatusContainer/Buffs/FrenzyIcon").refresh_status_icon(new_duration)
	$Timer.start(new_duration)
	$AnimatedSprite.play()

func _on_Timer_timeout():
	if body.get("ENEMY_NAME"):
		pass
	else:
		# body.set_attack_timescale(body.stats.attack_speed)
		# body.stats.attack_speed = body.stats.attack_speed
		body.stats.attack_speed_mod = 1.0
		body.set_stamina_attack_cost(body.stats.stamina_attack_cost)
		body.knockback_modifier = 1
	queue_free()

func _on_Frenzy_tree_exiting():
	emit_signal("frenzy_removed")
