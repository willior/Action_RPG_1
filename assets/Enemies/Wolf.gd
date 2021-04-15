extends KinematicBody2D

const BloodDeathEffect = preload("res://assets/Effects/Enemies/BloodDeathEffect.tscn")
const ExpNotice = preload("res://assets/UI/ExpNotice.tscn")
const DialogBox = preload("res://assets/UI/DialogBox.tscn")
const IngredientPickup = preload("res://assets/Ingredients/IngredientPickup.tscn")
var EnemySpawner = preload("res://assets/Spawners/EnemySpawner.tscn")
var attackSFX = preload("res://assets/Audio/Enemies/Wolf/Wolf_Attack_1.wav")
var detectSFX = preload("res://assets/Audio/Enemies/Wolf/Wolf_Growl_1.wav")
var hitSFX = preload("res://assets/Audio/Enemies/Wolf/Wolf_Hit_1.wav")

const ENEMY_NAME = "Wolf"
export var ACCELERATION = 800
export var MAX_SPEED = 48
export var WANDER_SPEED = 48
export var ATTACK_SPEED = 3200
export var FRICTION = 1600
export var WANDER_TARGET_RANGE = 4
export var ATTACK_TARGET_RANGE = 16

enum {
	IDLE,
	WANDER,
	CHASE,
	ATTACK,
	DEAD
}
var state = IDLE
var evasion_mod = 0

var velocity = Vector2.ZERO
# var dir_vector = Vector2.DOWN
var knockback = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var random_number

var interactable = false
var talkable = false
var examined = false
var seeking = false
var attacking = false
var attack_on_cooldown = false
var target
var currentAnim

onready var stats = $WolfStats
onready var timer = $Timer
onready var sprite = $Sprite
onready var eye = $Sprite/AnimatedSpriteEye
onready var tween = $Tween
onready var hitbox = $Hitbox
onready var hurtbox = $Hurtbox
onready var playerDetectionZone = $PlayerDetectionZone
onready var chaseTimer = $PlayerDetectionZone/ChaseTimer
onready var attackPlayerZone = $AttackPlayerZone
onready var attackTimer = $AttackPlayerZone/AttackTimer
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var attackController = $AttackController
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var audio = $AudioStreamPlayer
onready var enemyHealth = $EnemyHealth
onready var player = get_parent().get_parent().get_node("Player")

func _ready():
# warning-ignore:return_value_discarded
	PlayerLog.connect("Wolf_complete", self, "examine_complete")
	if PlayerLog.enemies_examined[ENEMY_NAME]:
		examined = true
	add_to_group("Enemies")
	# rng.randomize()
	# random_number = rng.randi_range(0, 4)
	animationTree.active = true
	Global.set_world_collision(self, z_index)
	# Enemy.set_player_collision(self)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta) # knockback friction
	knockback = move_and_slide(knockback)
	
	if velocity != Vector2.ZERO:
		animationTree.set("parameters/Idle/BlendSpace2D/blend_position", velocity)
		animationTree.set("parameters/Move/BlendSpace2D/blend_position", velocity)
		animationTree.set("parameters/Leap/BlendSpace2D/blend_position", velocity)
	
	match state:
		IDLE:
			animationState.travel("Idle")
			if stats.health <= 0:
				print(self.name, ' dead in idle state.')
				state = DEAD
				return
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0 && !seeking:
				update_wander_state()
				
		WANDER:
			animationState.travel("Move")
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander_state()
			
			accelerate_towards_point(wanderController.target_position, WANDER_SPEED, delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE: # when enemy arrives at its wander target
				update_wander_state()
				
		CHASE:
			if playerDetectionZone.player != null:
				animationState.travel("Move")
				accelerate_towards_point(playerDetectionZone.player.global_position, MAX_SPEED, delta)
				attack_player()
			else:
				#print('wolf lost sight of player.')
				eye.modulate = Color(0,0,0)
				eye.frame = sprite.frame
				state = IDLE
		ATTACK:
			animationState.travel("Leap")
			if attacking:
				attacking = false
				audio_attack()
				
			accelerate_towards_point(target, ATTACK_SPEED, delta)
			if global_position.distance_to(target) <= ATTACK_TARGET_RANGE:
				state = IDLE
				
		DEAD:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
		
	velocity = move_and_slide(velocity)
	
func reset_state():
	state = IDLE

func examine():
	var dialog_script = [
		{'text': "A common wolf. It looks friendly."},
		{'text': "Though it's probably safe to assume that it isn't."}
	]
	Enemy.examine(dialog_script, examined, ENEMY_NAME)

func examine_complete(value):
	examined = value
			
func accelerate_towards_point(point, speed, delta):
	var direction = global_position.direction_to(point) # gets the direction by grabbing the target position, the point argument
	velocity = velocity.move_toward(direction * speed, ACCELERATION * delta) # multiplies that by the speed argument
	Enemy.h_flip_handler(sprite, eye, velocity)

func seek_player(): # runs every frame of the IDLE and WANDER states
	if hitbox.monitorable:
		hitbox.set_deferred("monitorable", false)
	if playerDetectionZone.can_see_player() && !attacking && !seeking:
		#print('wolf sees player...')
		seeking = true
		state = IDLE
		audio_detect()
		eye.modulate = Color(1,0.8,0)
		eye.frame = sprite.frame
		chaseTimer.start()
		yield(chaseTimer, "timeout")
		#print('... and begins chasing')
		seeking = false
		state = CHASE

func attack_player():
	if attackPlayerZone.can_attack_player() && !attack_on_cooldown:
		target = attackPlayerZone.player.global_position
		disable_detection()
		attacking = true
		$DelayTimer.start()
		yield($DelayTimer, "timeout")
		if stats.health > 0:
			hitbox.set_deferred("monitorable", true)
			eye.modulate = Color(1,0,0)
			# eye.frame = sprite.frame
			attackTimer.start()
			state = ATTACK

func _on_AttackTimer_timeout():
	attack_on_cooldown = true
	eye.modulate = Color(0,0,0)
	eye.frame = sprite.frame
	state = IDLE
	timer.start()
	yield(timer, "timeout")
	if attack_on_cooldown:
		attack_on_cooldown = false
		enable_detection()

func disable_detection():
	Enemy.disable_detection(self)
#	attackPlayerZone.set_deferred("monitoring", false)
#	playerDetectionZone.set_deferred("monitoring", false)

func enable_detection():
	Enemy.enable_detection(self)
#	attackPlayerZone.set_deferred("monitoring", true)
#	playerDetectionZone.set_deferred("monitoring", true)

func update_wander_state():
	state = pick_random_state([IDLE, WANDER]) # feeds an array with the IDLE and WANDER states as its argument
	var state_rng = rand_range(2, 4)
	if state == 0: # IDLE STATE
		if state_rng > 3: # plays animation 25% of the time
			pass
		else:
			pass # otherwise plays the idle animation
	elif state == 1: # WANDER STATE
		Enemy.h_flip_handler(sprite, eye, velocity)
		wanderController.start_wander_timer(state_rng) # starts wander timer between 2s & 4s
		
func pick_random_state(state_list): 
	state_list.shuffle() # shuffles the order of the list of states recieved
	return state_list.pop_front() # spits one out
	
func create_hit_effect(_damage_count):
	pass

func _on_Hurtbox_area_entered(area):
	var hit = Enemy.hurtbox_entered(self, area)
	if hit:
		audio_hit()
		if stats.health <= 0:
			FRICTION = 600

#	$EnemyHealth.show_health()
#	if z_index != area.get_parent().get_parent().z_index:
#		SoundPlayer.play_sound("miss")
#		hurtbox.display_damage_popup("Miss!", false)
#		return
#	evasion_mod = 0
#	var hit = Global.player_hit_calculation(PlayerStats.base_accuracy, PlayerStats.dexterity, PlayerStats.dexterity_mod, stats.evasion+evasion_mod)
#	if !hit:
#		SoundPlayer.play_sound("miss")
#		hurtbox.display_damage_popup("Miss!", false)
#	else:
#		audio_hit()
#		var is_crit = Global.crit_calculation(PlayerStats.base_crit_rate, PlayerStats.dexterity, PlayerStats.dexterity_mod)
#		var damage = Global.damage_calculation(area.damage, stats.defense, area.randomness)
#		if is_crit:
#			damage *= 2
#		stats.health -= damage
#
#		var damage_count = min(damage/2, 32)
#		while damage_count > 0:
#			# create_hit_effect(damage_count)
#			Global.create_blood_effect(damage_count, global_position, z_index)
#			Global.create_blood_effect(damage_count, global_position, z_index)
#			damage_count -= 4
#
#		hurtbox.display_damage_popup(str(damage), is_crit)
#		hurtbox.create_hit_effect()
#		#hurtbox.start_invincibility(0.3)
#
#		sprite.modulate = Color(1,1,0)
#		if stats.health > 0:
#			knockback = area.knockback_vector * 120 # knockback velocity
#			tween.interpolate_property(sprite,
#			"modulate",
#			Color(1, 1, 0),
#			Color(1, 1, 1),
#			0.2,
#			Tween.TRANS_LINEAR,
#			Tween.EASE_IN
#			)
#			tween.start()
#		else:
#			FRICTION = 600
#			knockback = area.knockback_vector * 180 # knockback velocity on killing blow

func _on_Hurtbox_invincibility_started():
	animationPlayer.play("StartFlashing")

func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("StopFlashing")

func _on_WolfStats_no_health():
	disable_detection()
	hurtbox.set_deferred("monitoring", false) # turn off hurtbox
	#hitbox.set_deferred("monitorable", false)
	$Hitbox/CollisionShape2D.queue_free()
	animationPlayer.stop()
	state = DEAD
	tween.interpolate_property(sprite,
	"modulate",
	Color(1, 1, 0),
	Color(1, 0, 0),
	0.5,
	Tween.TRANS_LINEAR,
	Tween.EASE_IN
	)
	tween.start()
	yield(tween, "tween_all_completed")
	var bloodDeathEffect = BloodDeathEffect.instance()
	get_node("/root/World/Map").call_deferred("add_child", bloodDeathEffect)
	# enemyDeathEffect.enemy = ENEMY_NAME
	bloodDeathEffect.global_position = global_position
	bloodDeathEffect.z_index = z_index
	Global.create_blood_effect(40, global_position, z_index)
	Global.create_blood_effect(40, global_position, z_index)
	Global.create_blood_effect(40, global_position, z_index)
	Global.create_blood_effect(40, global_position, z_index)
	Global.create_blood_effect(40, global_position, z_index)
	Global.create_blood_effect(40, global_position, z_index)
	Global.create_blood_effect(40, global_position, z_index)
	Global.create_blood_effect(40, global_position, z_index)
	Global.create_blood_effect(40, global_position, z_index)
	Global.create_blood_effect(40, global_position, z_index)
	Global.create_blood_effect(40, global_position, z_index)
	Global.create_blood_effect(40, global_position, z_index)
	Global.create_blood_effect(32, global_position, z_index)
	Global.create_blood_effect(32, global_position, z_index)
	Global.create_blood_effect(32, global_position, z_index)
	Global.create_blood_effect(32, global_position, z_index)
	Global.distribute_exp(stats.experience_pool)
	var expNotice = ExpNotice.instance()
	expNotice.position = global_position
	expNotice.expDisplay = stats.experience_pool
	get_node("/root/World").add_child(expNotice)
	var ingredientPickup = IngredientPickup.instance()
	match randi() % 4: # random number between 0 & 3
		0:
			ingredientPickup.ingredient_name = "Rock"
		1:
			ingredientPickup.ingredient_name = "Clay"
		2:
			ingredientPickup.ingredient_name = "Salt"
		3:
			ingredientPickup.ingredient_name = "Water"
	get_node("/root/World/YSort/Items").call_deferred("add_child", ingredientPickup)
	ingredientPickup.global_position = global_position
	ingredientPickup.z_index = z_index
	queue_free()
	
func audio_detect():
	audio.stream = detectSFX
	audio.play()

func audio_attack():
	audio.stream = attackSFX
	audio.play()

func audio_hit():
	audio.stream = hitSFX
	audio.play()

func _on_VisibilityNotifier2D_screen_exited():
	if stats.health <= 0:
		return
	else:
		queue_free()
		var newEnemySpawner = EnemySpawner.instance()
		get_parent().call_deferred("add_child", newEnemySpawner)
		newEnemySpawner.ENEMY = load("res://assets/Enemies/Wolf.tscn")
		newEnemySpawner.health = stats.health
		newEnemySpawner.global_position = global_position
		newEnemySpawner.z_index = z_index
	
func set_health(value):
	stats.health = value
	# print(ENEMY_NAME, ' spawned, setting health to previous value: ', value)
