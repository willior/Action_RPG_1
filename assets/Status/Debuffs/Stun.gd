extends Node2D
var debuff
const Icon = preload("res://assets/UI/Status/Debuffs/StunIcon.tscn")
var duration = 2.0
onready var body = get_parent().get_parent()
signal stun_advanced(value)
signal stun_removed

func _ready():
	body.hurtbox.display_damage_popup("Stunned!", false, name)
	body.state = body.get("STUN")
	if body.get("ENEMY_NAME"):
		Enemy.disable_detection(body)
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

func interrupt_stun():
	body.state = 0 # body.get("IDLE")
	if body.get("ENEMY_NAME"):
		Enemy.enable_detection(body)
	queue_free()

func _on_Timer_timeout():
	body.state = 0 # body.get("IDLE")
	if body.get("ENEMY_NAME"):
		Enemy.enable_detection(body)
	queue_free()

func get_stun_time_remaining():
	return $Timer.get_time_left()

func advance_stun_time(new_time):
	$Timer.start(new_time)
	emit_signal("stun_advanced", new_time)
	
# STUN requires additional 3 condition checks on each enemy to occur.
# 1a. EITHER : during attack_player() function which called every frame of the CHASE states;
# 1b. OR : if there is a delay before attacking, when this DelayTimer times out;
# 2. when the AttackTimer times out;
# 3. after the attack cooldown reset timer times out.

func _on_Stun_tree_exiting():
	emit_signal("stun_removed")
