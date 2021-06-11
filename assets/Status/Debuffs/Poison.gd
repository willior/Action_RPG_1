extends Node2D
var debuff
const Icon = preload("res://assets/UI/Status/Debuffs/PoisonIcon.tscn")
var duration = 16 # number of ticks
var potency = 1 # damage per tick
onready var body = get_parent().get_parent()
signal poison_removed()

func _ready():
	body.hurtbox.display_damage_popup("Poisoned!", false, "Poison")
	if body.get("ENEMY_NAME"):
		pass
	else:
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

func _on_PoisonIndicator_animation_finished():
	if body.stats.health <= 0:
		queue_free()
	else:
		body.stats.health -= potency
		if body.get("enemyHealth"):
			body.enemyHealth.show_health()
		body.hurtbox.display_damage_popup(str(potency), false, "Poison")

func _on_Timer_timeout():
	queue_free()

func _on_PoisonNotice_tree_exiting():
	emit_signal("poison_removed")
