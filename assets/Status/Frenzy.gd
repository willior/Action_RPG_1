extends Node

const Icon = preload("res://assets/UI/Status/Buffs/FrenzyIcon.tscn")
export var duration = 3 # duration in seconds
export var potency = 2 # attack speed multiplier
onready var body = get_parent()
signal frenzy_removed()

func _ready():
	body.hurtbox.display_damage_popup("Frenzy", false, "Red")
	if body.get("ENEMY_NAME"):
		pass
	else:
		var icon = Icon.instance()
		icon.duration = duration
		get_node("/root/World/GUI/StatusDisplay1/StatusContainer/Buffs").add_child(icon)
	$Timer.start(duration)
	body.set_attack_timescale(PlayerStats.attack_speed*2)

func refresh_status():
	get_node("/root/World/GUI/StatusDisplay1/StatusContainer/Buffs/FrenzyIcon").refresh_status_icon()
	$Timer.start(duration)
	body.set_attack_timescale(PlayerStats.attack_speed*2)

func _on_Timer_timeout():
	body.set_attack_timescale(PlayerStats.attack_speed)
	queue_free()

func _on_Frenzy_tree_exiting():
	emit_signal("frenzy_removed")
