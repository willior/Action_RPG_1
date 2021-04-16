extends Node2D

const EnemyDeathEffect = preload("res://assets/Effects/EnemyDeathEffect.tscn")
const ExpNotice = preload("res://assets/UI/ExpNotice.tscn")
const DialogBox = preload("res://assets/UI/DialogBox.tscn")
const IngredientPickup = preload("res://assets/Ingredients/IngredientPickup.tscn")
var EnemySpawner = preload("res://assets/Spawners/EnemySpawner.tscn")

# GENERIC ENEMY CLASS / REFACTOR PROJECT

# common elements of the bat & crow go into a generic enemy class.
# if their values need to be modified, export the appropriate variables.
# the “bat” & “crow” classes, after their shared code has been refactored,
# should extend this generic “enemy” class.

enum {
	IDLE,
	WANDER,
	CHASE,
	ATTACK,
	DEAD
}

func h_flip_handler(sprite, eye, velocity):
	sprite.flip_h = velocity.x < 0
	eye.flip_h = velocity.x < 0

func set_player_collision(body):
	var player = get_node("/root/World/YSort/Player")
	if player.z_index == body.z_index:
		body.set_collision_layer_bit(4, true)
		body.disable_detection()
		body.enable_detection()
	else:
		body.set_collision_layer_bit(4, false)

func examine(dialog_script, examined, enemy_name):
	var dialogBox = DialogBox.instance()
	dialogBox.dialog_script = dialog_script
	get_node("/root/World/GUI").add_child(dialogBox)
	if !examined:
		examined = true
		PlayerLog.set_examined(enemy_name, true)

func disable_detection(enemy):
	enemy.attackPlayerZone.set_deferred("monitoring", false)
	enemy.playerDetectionZone.set_deferred("monitoring", false)
	
func enable_detection(enemy):
	enemy.attackPlayerZone.set_deferred("monitoring", true)
	enemy.playerDetectionZone.set_deferred("monitoring", true)

func hurtbox_entered(enemy, hitbox):
	enemy.enemyHealth.show_health()
	if hitbox.spell:
		var damage = Global.damage_calculation(hitbox.damage, enemy.stats.defense, hitbox.randomness)
		deal_damage(enemy, damage, false)
		if enemy.stats.health > 0:
			enemy.knockback = hitbox.knockback_vector * 120 # knockback velocity
			enemy.tween.interpolate_property(enemy.sprite,
			"modulate",
			Color(1, 0.8, 0),
			Color(1, 1, 1),
			0.2,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN
			)
			enemy.tween.start()
		else:
			enemy.knockback = hitbox.knockback_vector * 180 # knockback velocity on killing blow
		return true
	
	if enemy.z_index != hitbox.get_parent().get_parent().z_index:
		SoundPlayer.play_sound("miss")
		enemy.hurtbox.display_damage_popup("Miss!", false)
		return
	var hit = Global.player_hit_calculation(PlayerStats.base_accuracy, PlayerStats.dexterity, PlayerStats.dexterity_mod, enemy.stats.evasion+enemy.evasion_mod)
	if !hit:
		SoundPlayer.play_sound("miss")
		enemy.hurtbox.display_damage_popup("Miss!", false)
	else:
		var is_crit = Global.crit_calculation(PlayerStats.base_crit_rate, PlayerStats.dexterity, PlayerStats.dexterity_mod)
		var damage = Global.damage_calculation(hitbox.damage, enemy.stats.defense, hitbox.randomness)
		if is_crit:
			damage *= 2
		deal_damage(enemy, damage, is_crit)
		if enemy.stats.health > 0:
			enemy.knockback = hitbox.knockback_vector * 120 # knockback velocity
			enemy.tween.interpolate_property(enemy.sprite,
			"modulate",
			Color(1, 0.8, 0),
			Color(1, 1, 1),
			0.2,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN
			)
			enemy.tween.start()
		else:
			enemy.knockback = hitbox.knockback_vector * 180 # knockback velocity on killing blow
	return hit

func deal_damage(enemy, damage, is_crit):
	damage = min(damage, 9999)
	enemy.stats.health -= damage
	var damage_count = min(damage/2, 32)
	while damage_count > 0:
		enemy.create_hit_effect(damage_count)
		Global.create_blood_effect(damage_count, enemy.global_position, enemy.z_index)
		Global.create_blood_effect(damage_count, enemy.global_position, enemy.z_index)
		damage_count -= 4
	
	enemy.hurtbox.display_damage_popup(str(damage), is_crit)
	enemy.hurtbox.create_hit_effect()
	enemy.hurtbox.start_invincibility(0.05)
	enemy.sprite.modulate = Color(1,1,0)
