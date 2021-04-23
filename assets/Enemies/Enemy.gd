extends Node2D

# const EnemyDeathEffect = preload("res://assets/Effects/EnemyDeathEffect.tscn")
const ExpNotice = preload("res://assets/UI/ExpNotice.tscn")
const DialogBox = preload("res://assets/UI/DialogBox.tscn")
const IngredientPickup = preload("res://assets/Ingredients/IngredientPickup.tscn")
const EnemySpawner = preload("res://assets/Spawners/EnemySpawner.tscn")

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
		Enemy.disable_detection(body)
		Enemy.enable_detection(body)
#		body.disable_detection()
#		body.enable_detection()
	else:
		body.set_collision_layer_bit(4, false)

func examine(dialog_script, examined, enemy_name):
	var dialogBox = DialogBox.instance()
	dialogBox.dialog_script = dialog_script
	get_node("/root/World/GUI").add_child(dialogBox)
	if !examined:
		examined = true
		PlayerLog.set_examined(enemy_name, true)
		
func accelerate_towards_point(enemy, point, speed, delta):
	var direction = enemy.global_position.direction_to(point) # gets the direction by grabbing the target position, the point argument
	enemy.velocity = enemy.velocity.move_toward(direction * speed, enemy.ACCELERATION * delta) # multiplies that by the speed argument

func disable_detection(enemy):
	enemy.attackPlayerZone.set_deferred("monitoring", false)
	enemy.playerDetectionZone.set_deferred("monitoring", false)
	
func enable_detection(enemy):
	enemy.attackPlayerZone.set_deferred("monitoring", true)
	enemy.playerDetectionZone.set_deferred("monitoring", true)

func hurtbox_entered(enemy, hitbox):
	enemy.enemyHealth.show_health()
	if hitbox.formula:
		var damage = Global.damage_calculation(hitbox.potency, enemy.stats.defense, hitbox.randomness)
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
			enemy.knockback = hitbox.knockback_vector * 180 # knockback velocity on kill
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
	
func no_health(enemy, death_effect):
	enemy.hurtbox.set_deferred("monitoring", false) # turn off hurtbox
	enemy.hitbox.set_deferred("monitorable", false)
	enemy.state = DEAD
	enemy.tween.interpolate_property(enemy.sprite,
	"modulate",
	Color(1, 1, 0),
	Color(1, 0, 0),
	0.5,
	Tween.TRANS_LINEAR,
	Tween.EASE_IN
	)
	enemy.tween.start()
	yield(get_tree().create_timer(0.5), "timeout")
	death_effect.global_position = enemy.global_position
	death_effect.z_index = enemy.z_index
	get_node("/root/World/Map").call_deferred("add_child", death_effect)
	for i in range(16,0,-2):
		Global.create_blood_effect(i, enemy.global_position, enemy.z_index)
	Global.distribute_exp(enemy.stats.experience_pool)
	var expNotice = ExpNotice.instance()
	expNotice.position = enemy.global_position
	expNotice.expDisplay = enemy.stats.experience_pool
	get_node("/root/World").add_child(expNotice)
	Global.ingredient_drop(enemy.common_drop_name, enemy.common_drop_chance, enemy.rare_drop_name, enemy.rare_drop_chance, enemy.global_position, enemy.z_index)
	enemy.queue_free()

func despawn_offscreen(enemy):
	if enemy.stats.health <= 0:
		return
	else:
		enemy.queue_free()
		var newEnemySpawner = EnemySpawner.instance()
		enemy.get_parent().call_deferred("add_child", newEnemySpawner)
		newEnemySpawner.ENEMY = enemy.filename
		newEnemySpawner.health = enemy.stats.health
		newEnemySpawner.global_position = enemy.global_position
		newEnemySpawner.z_index = enemy.z_index

func set_health(enemy, health):
	enemy.stats.health = health
