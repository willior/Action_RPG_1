extends Node2D

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
		body.set_attack_timescale(body.stats.attack_speed*potency)
		body.set_stamina_attack_cost(body.stats.stamina_attack_cost/5)
		match body.name:
			"Player":
				var icon = Icon.instance()
				icon.duration = duration
				icon.status_nodepath = self.get_path()
				get_node("/root/World/GUI/StatusDisplay1/StatusContainer/Buffs").add_child(icon)
	$Timer.start(duration)
	$AnimatedSprite.play()

func refresh_status(new_duration, new_potency):
	body.hurtbox.display_damage_popup("Frenzy", false, "Red")
	if body.get("ENEMY_NAME"):
		pass
	else:
		body.set_attack_timescale(body.stats.attack_speed*new_potency)
		body.set_stamina_attack_cost(body.stats.stamina_attack_cost/5)
		match body.name:
			"Player":
				get_node("/root/World/GUI/StatusDisplay1/StatusContainer/Buffs/FrenzyIcon").refresh_status_icon(new_duration)
	$Timer.start(new_duration)
	$AnimatedSprite.play()

func _on_Timer_timeout():
	if body.get("ENEMY_NAME"):
		pass
	else:
		body.set_attack_timescale(body.stats.attack_speed)
		body.set_stamina_attack_cost(body.stats.stamina_attack_cost)
	queue_free()

func _on_Frenzy_tree_exiting():
	emit_signal("frenzy_removed")
