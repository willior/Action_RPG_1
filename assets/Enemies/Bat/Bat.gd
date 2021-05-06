extends KinematicBody2D
const ENEMY_NAME = "Bat"
const EnemyDeathEffect = preload("res://assets/Effects/EnemyDeathEffect.tscn")
const DialogBox = preload("res://assets/UI/DialogBox.tscn")
const EnemySpawner = preload("res://assets/Spawners/EnemySpawner.tscn")

export var ACCELERATION = 240
export var MAX_SPEED = 40
export var WANDER_SPEED = 20
export var ATTACK_SPEED = 90
export var FRICTION = 240
export var WANDER_TARGET_RANGE = 4
export var ATTACK_TARGET_RANGE = 4

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
var knockback = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var random_number

var interactable = false
var talkable = false
var examined = false
var attacking = false
var attack_on_cooldown = false
var target
var facingLeft = false
var common_drop_name = "Water"
var common_drop_chance = 0.50
var rare_drop_name = "Clay"
var rare_drop_chance = 0.125

onready var stats = $BatStats
onready var timer = $Timer
onready var sprite = $AnimatedSprite
onready var eye = $AnimatedSprite/AnimatedSpriteEye
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
onready var audio = $AudioStreamPlayer
onready var enemyHealth = $EnemyHealth
onready var player = get_parent().get_parent().get_node("Player")

func _ready():
# warning-ignore:return_value_discarded
	PlayerLog.connect("Bat_complete", self, "examine_complete")
	if PlayerLog.enemies_examined[ENEMY_NAME]:
		examined = true
	add_to_group("Enemies")
	rng.randomize()
	random_number = rng.randi_range(0, 4)
	sprite.frame = random_number
	eye.frame = sprite.frame
	set_speed_scale(1)
	sprite.playing = true
	eye.playing = true
	Global.set_world_collision(self, z_index)

func set_speed_scale(value):
	sprite.speed_scale = value
	eye.speed_scale = sprite.speed_scale
	eye.frame = sprite.frame

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
			accelerate_towards_point(wanderController.target_position, WANDER_SPEED, delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE: # when enemy arrives at its wander target
				update_wander_state()
				
		CHASE:
			if playerDetectionZone.player != null:
				accelerate_towards_point(playerDetectionZone.player.global_position, MAX_SPEED, delta)
				attack_player()
			else:
				set_speed_scale(1)
				eye.modulate = Color(0,0,0)
				state = IDLE
		ATTACK:
			if attacking:
				audio.play()
				attacking = false
			accelerate_towards_point(target, ATTACK_SPEED, delta)
			if global_position.distance_to(player.global_position) <= ATTACK_TARGET_RANGE:
				set_speed_scale(1)
				state = IDLE
		DEAD:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		STUN:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
		
	velocity = move_and_slide(velocity)

func examine():
	var dialog_script = [
		{'text': "Bats are mammals of the Chiroptera order."},
		{'text': "They are the only mammals capable of true and sustained flight."}
	]
	Enemy.examine(dialog_script, examined, ENEMY_NAME)

func examine_complete(value):
	examined = value

func accelerate_towards_point(point, speed, delta):
	Enemy.accelerate_towards_point(self, point, speed, delta)
	Enemy.h_flip_handler(sprite, eye, velocity)

func seek_player():
	if playerDetectionZone.can_see_player() && !attacking:
		set_speed_scale(2)
		eye.modulate = Color(1,0.8,0)
		state = CHASE

func attack_player():
	if attackPlayerZone.can_attack_player() && !attack_on_cooldown:
		print('attacking player')
		target = attackPlayerZone.player.global_position
		Enemy.disable_detection(self)
		attacking = true
		
		$DelayTimer.start()
		yield($DelayTimer, "timeout")
		print('delay timer timeout...')
		
		if state == STUN:
			print('... stunned during delay timer timeout; no attack.')
			attacking = false
			return
		
		hitbox.set_deferred("monitorable", true)
		set_speed_scale(4)
		eye.modulate = Color(1,0,0)
		
		attackTimer.start()
		state = ATTACK

func _on_AttackTimer_timeout():
	print('attack timer timeout...')
	attack_on_cooldown = true
	hitbox.set_deferred("monitorable", false)
	set_speed_scale(1)
	eye.modulate = Color(0,0,0)
	
	if state == STUN:
		print('...while stunned; resetting cooldown')
		attacking = false
		attack_on_cooldown = false
		return
	
	state = IDLE
	timer.start()
	yield(timer, "timeout")
	
	if attack_on_cooldown:
		print('...resetting cooldown and re-enabling detection')
		attack_on_cooldown = false
		
		if state == STUN:
			('cooldown reset during stun; detection NOT re-enabled')
			return
		
		Enemy.enable_detection(self)

func update_wander_state():
	hitbox.set_deferred("monitorable", false)
	state = pick_random_state([IDLE, WANDER]) # feeds an array with the IDLE and WANDER states as its argument
	wanderController.start_wander_timer(rand_range(1, 3)) # starts wander timer between 1s & 3s

func pick_random_state(state_list): 
	state_list.shuffle() # shuffles the order of the list of states recieved
	return state_list.pop_front() # spits one out

func create_hit_effect(_damage_count):
	pass

func _on_Hurtbox_area_entered(area): # runs when a hitbox enters the bat's hurtbox
	var hit = Enemy.hurtbox_entered(self, area)
	if hit && state == ATTACK && state != STUN:
		state = IDLE

func _on_BatStats_no_health():
	var death_effect = EnemyDeathEffect.instance()
	Enemy.no_health(self, death_effect)
	sprite.playing = false # stop animation
	tween.interpolate_property(sprite,
	"offset:y",
	-12,
	0,
	0.5,
	Tween.TRANS_QUART,
	Tween.EASE_IN
	)
	tween.interpolate_property(eye,
	"offset:y",
	-12,
	0,
	0.5,
	Tween.TRANS_QUART,
	Tween.EASE_IN
	)

func _on_Hurtbox_invincibility_started():
	animationPlayer.play("StartFlashing")

func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("StopFlashing")

func _on_VisibilityNotifier2D_screen_exited():
	Enemy.despawn_offscreen(self)
