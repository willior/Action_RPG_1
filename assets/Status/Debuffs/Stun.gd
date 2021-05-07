extends Node2D

onready var body = get_parent()

func _ready():
	print(body.name, ' is stunned!')
	body.hurtbox.display_damage_popup("Stunned!", false)
	body.state = body.get("STUN")
	if body.get("ENEMY_NAME"):
		Enemy.disable_detection(body)

func interrupt_stun():
	print('stun interrupted on ', body.name, '; deleting.')
	body.state = 0 # body.get("IDLE")
	if body.get("ENEMY_NAME"):
		Enemy.enable_detection(body)
	queue_free()

func _on_Timer_timeout():
	print(body.name, ' recovered from stun; deleting.')
	body.state = 0 # body.get("IDLE")
	if body.get("ENEMY_NAME"):
		Enemy.enable_detection(body)
	queue_free()

func get_stun_time_remaining():
	return $Timer.get_time_left()

# STUN requires additional 3 condition checks on each enemy to occur.
# 1a. EITHER : during attack_player() function which called every frame of the CHASE states;
# 1b. OR : if there is a delay before attacking, when this DelayTimer times out;
# 2. when the AttackTimer times out;
# 3. after the attack cooldown reset timer times out.
