extends KinematicBody2D
const ENEMY_NAME = "Wolf"
const EnemyDeathEffect = preload("res://assets/Effects/Enemies/BloodDeathEffect.tscn")
const DialogBox = preload("res://assets/UI/DialogBox.tscn")
const EnemySpawner = preload("res://assets/Spawners/EnemySpawner.tscn")

const attackSFX = preload("res://assets/Audio/Enemies/Wolf/Wolf_Attack_1.wav")
const detectSFX = preload("res://assets/Audio/Enemies/Wolf/Wolf_Growl_1.wav")
const hitSFX = preload("res://assets/Audio/Enemies/Wolf/Wolf_Hit_1.wav")

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
	DEAD,
	STUN
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
var common_drop_name = "Clay"
var common_drop_chance = 0.50
var rare_drop_name = "Salt"
var rare_drop_chance = 0.125

onready var stats = $WolfStats
onready var cooldownTimer = $CooldownTimer
onready var sprite = $Sprite
onready var eye = $Sprite/SpriteEye
onready var outline = $Sprite/Outline
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

func _ready():
# warning-ignore:return_value_discarded
	PlayerLog.connect("Wolf_complete", self, "examine_complete")
	if ENEMY_NAME in PlayerLog.examined_list:
		examined = true
	add_to_group("Enemies")
	animationTree.active = true
	Global.set_world_collision(self, z_index)

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
			elif !attacking:
				eye.modulate = Color(0,0,0,0)
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
		STUN:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			animationState.travel("Idle")
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400

	velocity = move_and_slide(velocity)
	outline.frame = sprite.frame

func reset_state():
	$DelayTimer.stop()
	cooldownTimer.stop()
	seeking = false
	attacking = false
	attack_on_cooldown = false
	state = IDLE
	Enemy.enable_detection(self)

func examine():
	var dialog_script = [
		{'text': "A common wolf. It looks friendly."},
		{'text': "Though it's probably safe to assume that it isn't."}
	]
	Enemy.examine(dialog_script, examined, ENEMY_NAME)

func examine_complete(value):
	examined = value

func accelerate_towards_point(point, speed, delta):
	Enemy.accelerate_towards_point(self, point, speed, delta)
	Enemy.h_flip_handler(sprite, eye, velocity)
	outline.flip_h = velocity.x < 0

func seek_player(): # runs every frame of the IDLE and WANDER states
	if playerDetectionZone.can_see_player() && !attacking && !seeking:
		seeking = true
		state = IDLE
		audio_detect()
		eye.modulate = Color(1,0.8,0,1)
		chaseTimer.start()
		yield(chaseTimer, "timeout")
		seeking = false
		if state == STUN:
			eye.modulate = Color(0,0,0,0)
			return
		state = CHASE

func attack_player():
	if attackPlayerZone.can_attack_player() && !attack_on_cooldown:
		target = attackPlayerZone.player.global_position
		Enemy.disable_detection(self)
		attacking = true
		eye.modulate = Color(1,0,0,1)
		$DelayTimer.start()
		yield($DelayTimer, "timeout")
		if state == STUN:
			eye.modulate = Color(0,0,0,0)
			attacking = false
			return
		if stats.health > 0:
			hitbox.set_deferred("monitorable", true)
			attackTimer.start()
			state = ATTACK

func _on_AttackTimer_timeout():
	attack_on_cooldown = true
	eye.modulate = Color(0,0,0,0)
	hitbox.set_deferred("monitorable", false)
	if state == STUN:
		attack_on_cooldown = false
		attacking = false
		return
	state = IDLE
	cooldownTimer.start()
	yield(cooldownTimer, "timeout")
	if attack_on_cooldown:
		attack_on_cooldown = false
		if state == STUN:
			return
		Enemy.enable_detection(self)

func update_wander_state():
	hitbox.set_deferred("monitorable", false)
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

func _on_Hurtbox_invincibility_started():
	animationPlayer.play("StartFlashing")

func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("StopFlashing")

func _on_WolfStats_no_health():
	var death_effect = EnemyDeathEffect.instance()
	Enemy.no_health(self, death_effect)
	$Hitbox/CollisionShape2D.queue_free()
	animationPlayer.stop()
	Enemy.disable_detection(self)
	yield(get_tree().create_timer(0.5), "timeout")
	for i in range (16, 32):
		Global.create_blood_effect(i, global_position, z_index)

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
	Enemy.despawn_offscreen(self)

func show_outline():
	outline.show()

func hide_outline():
	outline.hide()
