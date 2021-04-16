extends KinematicBody2D
const ENEMY_NAME = "Crow"
const EnemyDeathEffect = preload("res://assets/Effects/Enemies/Crow_DeathEffect.tscn")
const EnemyHitEffect = preload("res://assets/Effects/Enemies/Crow_HitEffect.tscn")
const BloodHitEffect = preload("res://assets/Effects/Blood_HitEffect.tscn")
const ExpNotice = preload("res://assets/UI/ExpNotice.tscn")
const DialogBox = preload("res://assets/UI/DialogBox.tscn")
const IngredientPickup = preload("res://assets/Ingredients/IngredientPickup.tscn")
var EnemySpawner = preload("res://assets/Spawners/EnemySpawner.tscn")
const attackSFX = preload("res://assets/Audio/Enemies/Crow/Crow_cawcawcaw.wav")
const hitSFX = preload("res://assets/Audio/Enemies/Crow/Crow_caw.wav")

export var ACCELERATION = 200
export var MAX_SPEED = 400
export var WANDER_SPEED = 80
export var ATTACK_SPEED = 6000
export var FRICTION = 320
export var WANDER_TARGET_RANGE = 4
export var ATTACK_TARGET_RANGE = 4

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
var knockback = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var random_number

var interactable = false
var talkable = false
var examined = false
var attacking = false
var attack_on_cooldown = false
var target
var flying
var currentAnim

onready var stats = $CrowStats
onready var timer = $Timer
onready var sprite = $Sprite
onready var eye = $Sprite/AnimatedSpriteEye
onready var tween = $Tween
onready var hitbox = $Hitbox
onready var hurtbox = $Hurtbox
onready var playerDetectionZone = $PlayerDetectionZone
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
	PlayerLog.connect("Crow_complete", self, "examine_complete")
	if PlayerLog.enemies_examined[ENEMY_NAME]:
		examined = true
	add_to_group("Enemies")
	animationTree.active = true
	Enemy.set_player_collision(self)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta) # knockback friction
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander_state()
				
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander_state()
			
			fly_animation()
			accelerate_towards_point(wanderController.target_position, WANDER_SPEED, delta)
			
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE: # when enemy arrives at its wander target
				update_wander_state()
				
		CHASE:
			if playerDetectionZone.player != null:
				accelerate_towards_point(playerDetectionZone.player.global_position, MAX_SPEED, delta)
				attack_player()
			else:
				eye.modulate = Color(0,0,0)
				eye.frame = sprite.frame
				state = IDLE

		ATTACK:
			if attacking:
				attacking = false
				audio_cawcawcaw()
				fly_animation()
				
			accelerate_towards_point(target, ATTACK_SPEED, delta)
			if global_position.distance_to(target) <= ATTACK_TARGET_RANGE:
				state = IDLE
		DEAD:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
		
	velocity = move_and_slide(velocity)
	
func examine():
	var dialog_script = [
		{'text': "A common crow."},
		{'text': "Except that it's grossly over-sized."}
	]
	Enemy.examine(dialog_script, examined, ENEMY_NAME)

func examine_complete(value):
	examined = value
			
func accelerate_towards_point(point, speed, delta):
	if flying:
		var direction = global_position.direction_to(point) # gets the direction by grabbing the target position, the point argument
		velocity = velocity.move_toward(direction * speed, ACCELERATION * delta) # multiplies that by the speed argument
		Enemy.h_flip_handler(sprite, eye, velocity)

func seek_player():
	hitbox.set_deferred("monitorable", false)
	if playerDetectionZone.can_see_player() && !attacking:
		# animationState.travel("Fly")
		fly_animation()
		eye.modulate = Color(1,0.8,0)
		eye.frame = sprite.frame
		state = CHASE

func attack_player():
	if attackPlayerZone.can_attack_player() && !attack_on_cooldown:
		target = attackPlayerZone.player.global_position
		disable_detection()
		attacking = true
#		$DelayTimer.start()
#		yield($DelayTimer, "timeout")
		hitbox.set_deferred("monitorable", true)
		eye.modulate = Color(1,0,0)
		eye.frame = sprite.frame
		attackTimer.start()
		state = ATTACK
		
func _on_AttackTimer_timeout():
	attack_on_cooldown = true
	eye.modulate = Color(0,0,0)
	eye.frame = sprite.frame
	state = IDLE
	timer.start(1.2)
	yield(timer, "timeout")
	if attack_on_cooldown:
		attack_on_cooldown = false
		enable_detection()
	
func disable_detection():
	Enemy.disable_detection(self)

func enable_detection():
	Enemy.enable_detection(self)

func update_wander_state():
	state = pick_random_state([IDLE, WANDER]) # feeds an array with the IDLE and WANDER states as its argument
	var state_rng = rand_range(2, 4)
	if state == 0: # IDLE STATE
		if state_rng > 3: # plays the "Peck" animation 25% of the time
			animationState.travel("Peck")
		else:
			animationState.travel("Idle") # otherwise plays the idle animation
	elif state == 1: # WANDER STATE
		fly_animation()
	
	wanderController.start_wander_timer(state_rng) # starts wander timer between 2s & 4s
		
func pick_random_state(state_list): 
	state_list.shuffle() # shuffles the order of the list of states recieved
	return state_list.pop_front() # spits one out
	
func create_hit_effect(damage_count):
	var hit_effect = EnemyHitEffect.instance()
	var randX = int(rand_range(-damage_count, damage_count))
	var randY = int(rand_range(-damage_count/2, damage_count))
	hit_effect.global_position = global_position
	hit_effect.z_index = z_index
	hit_effect.target_position = global_position + Vector2(randX, randY)
	get_node("/root/World/Map").call_deferred("add_child", hit_effect)

func _on_Hurtbox_area_entered(area):
	var hit = Enemy.hurtbox_entered(self, area)
	if hit:
		if state == ATTACK:
			wanderController.start_wander_timer(1)
		if attacking:
			attacking = false
		animationState.travel("Landing")
		audio_caw()

func _on_Hurtbox_invincibility_started():
	animationPlayer.play("StartFlashing")

func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("StopFlashing")

func _on_CrowStats_no_health():
	# sprite.playing = false # stop animation
	hurtbox.set_deferred("monitoring", false) # turn off hurtbox
	hitbox.set_deferred("monitorable", false)
	state = DEAD
	tween.interpolate_property(sprite,
	"offset:y",
	-16,
	0,
	0.5,
	Tween.TRANS_QUART,
	Tween.EASE_IN
	)
	tween.interpolate_property(eye,
	"offset:y",
	-16,
	0,
	0.5,
	Tween.TRANS_QUART,
	Tween.EASE_IN
	)
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
	# player.enemy_killed(stats.experience_pool)
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_node("/root/World/Map").call_deferred("add_child", enemyDeathEffect)
	# enemyDeathEffect.enemy = ENEMY_NAME
	enemyDeathEffect.global_position = global_position
	enemyDeathEffect.z_index = z_index
	create_hit_effect(32)
	create_hit_effect(32)
	create_hit_effect(32)
	create_hit_effect(32)
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

func idle_animation():
	animationState.travel("Idle")
	
func fly_animation():
	animationState.travel("Fly")
	
func set_flying(value):
	flying = value
	if !flying:
		evasion_mod = 0
		set_collision_mask_bit(17, true)
	elif flying:
		evasion_mod = 32
		if z_index == 0:
			set_collision_mask_bit(17, false)

func audio_caw():
	audio.stream = hitSFX
	audio.play()
	
func audio_cawcawcaw():
	audio.stream = attackSFX
	audio.play()

func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	if stats.health <= 0:
		return
	else:
		queue_free()
		var newEnemySpawner = EnemySpawner.instance()
		get_parent().call_deferred("add_child", newEnemySpawner)
		newEnemySpawner.ENEMY = load("res://assets/Enemies/Crow/Crow.tscn")
		newEnemySpawner.health = stats.health
		newEnemySpawner.global_position = global_position
		newEnemySpawner.z_index = z_index
	
func set_health(value):
	stats.health = value