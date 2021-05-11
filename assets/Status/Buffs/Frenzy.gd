extends Node2D

const Icon = preload("res://assets/UI/Status/Buffs/FrenzyIcon.tscn")
var duration = 3.0
var potency = 1.5
onready var body = get_parent().get_parent()
signal frenzy_removed()

func _ready():
	body.hurtbox.display_damage_popup("Frenzy", false, "Red")
	if body.get("ENEMY_NAME"):
		pass
	else:
		body.set_attack_timescale(PlayerStats.attack_speed*potency)
		body.set_stamina_attack_cost(PlayerStats.stamina_attack_cost/5)
		var icon = Icon.instance()
		icon.duration = duration
		get_node("/root/World/GUI/StatusDisplay1/StatusContainer/Buffs").add_child(icon)
	$Timer.start(duration)
	$AnimatedSprite.play()

func refresh_status():
	get_node("/root/World/GUI/StatusDisplay1/StatusContainer/Buffs/FrenzyIcon").refresh_status_icon()
	$Timer.start(duration)
	if body.get("ENEMY_NAME"):
		pass
	else:
		body.set_attack_timescale(PlayerStats.attack_speed*potency)
		body.set_stamina_attack_cost(PlayerStats.stamina_attack_cost/5)

func _on_Timer_timeout():
	if body.get("ENEMY_NAME"):
		pass
	else:
		body.set_attack_timescale(PlayerStats.attack_speed)
		body.set_stamina_attack_cost(PlayerStats.stamina_attack_cost)
	queue_free()

func _on_Frenzy_tree_exiting():
	emit_signal("frenzy_removed")
