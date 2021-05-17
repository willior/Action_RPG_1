extends Node2D

const Icon = preload("res://assets/UI/Status/Buffs/RegenIcon.tscn")
var duration # number of ticks
var potency # damage per tick
onready var body = get_parent().get_parent()
signal regen_removed()

func _ready():
	body.hurtbox.display_damage_popup("Regen", false, "Heal")
	if body.get("ENEMY_NAME"):
		pass
	else:
		var icon = Icon.instance()
		icon.duration = duration
		get_node("/root/World/GUI/StatusDisplay1/StatusContainer/Buffs").add_child(icon)
	$Timer.start(duration)
	$AnimatedSprite.play()

func refresh_status(new_duration, new_potency):
	body.hurtbox.display_damage_popup("Regen", false, "Heal")
	if body.get("ENEMY_NAME"):
		pass
	else:
		get_node("/root/World/GUI/StatusDisplay1/StatusContainer/Buffs/RegenIcon").refresh_status_icon(new_duration)
	$Timer.start(new_duration)
	potency = new_potency

func _on_RegenIndicator_animation_finished():
	body.stats.health += potency
	if body.get("enemyHealth"):
		body.enemyHealth.show_health()
	body.hurtbox.display_damage_popup(str(potency), false, "Heal")

func _on_Timer_timeout():
	queue_free()

func _on_RegenIndicator_tree_exiting():
	emit_signal("regen_removed")
