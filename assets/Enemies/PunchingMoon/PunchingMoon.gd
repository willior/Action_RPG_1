extends KinematicBody2D
const ENEMY_NAME = "PunchingMoon"
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
var facingLeft = false
var common_drop_name = "Water"
var common_drop_chance = 0.50
var rare_drop_name = "Clay"
var rare_drop_chance = 0.125

onready var stats = $PunchingMoonStats
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
onready var audio = $AudioStreamPlayer
onready var enemyHealth = $EnemyHealth
onready var player = get_parent().get_parent().get_node("Player")

func _ready():
# warning-ignore:return_value_discarded
	PlayerLog.connect("PunchingMoon_complete", self, "examine_complete")
	if PlayerLog.enemies_examined[ENEMY_NAME]:
		examined = true
	add_to_group("Enemies")
	Global.set_world_collision(self, z_index)

func _physics_process(delta):
#	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta) # knockback friction
#	knockback = move_and_slide(knockback)
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
				eye.modulate = Color(0,0,0)
				state = IDLE
		ATTACK:
			if attacking:
				audio.play()
				attacking = false
			accelerate_towards_point(target, ATTACK_SPEED, delta)
			if global_position.distance_to(player.global_position) <= ATTACK_TARGET_RANGE:
				state = IDLE
		DEAD:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
				
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
		
	velocity = move_and_slide(velocity)

func examine():
	var dialog_script = [
		{'text': "Looks like the moon has abandoned the night sky to become your punching bag."},
		{'text': "Wonder how he feels about it."}
	]
	Enemy.examine(dialog_script, examined, ENEMY_NAME)

func examine_complete(value):
	examined = value

func accelerate_towards_point(point, speed, delta):
	Enemy.accelerate_towards_point(self, point, speed, delta)
	Enemy.h_flip_handler(sprite, eye, velocity)

func seek_player():
	return
# warning-ignore:unreachable_code
	hitbox.set_deferred("monitorable", false)
	if playerDetectionZone.can_see_player() && !attacking:
		eye.modulate = Color(1,0.8,0)
		state = CHASE

# attacking
# the attack_player() function is run when the enemy is in the CHASE state
# if that player enters the enemy's attackPlayerZone AND the attack is NOT on cooldown:
# 1. detection is disabled;
# 2. attacking is set to true;
# 3. enables the enemy's hitbox and quadruples the sprite animation speed
# 4. changes the state to ATTACK and starts the attackTimer (0.8s)
# 5. ATTACK state: gets the player's position point before setting attacking to false
# 6. accelerates the enemy to the player's position point
# 7A. if the enemy arrives at the point, resets the sprite animation speed and state to IDLE
# 7B. on attackTimer_timeout, attack_on_cooldown becomes true
#     disables hitbox
#     resets sprite animation speed and state to IDLE
#     starts a 1s timer, after which attack_on_cooldown becomes false
#     enemy detection is re-enabled

func attack_player():
	if attackPlayerZone.can_attack_player() && !attack_on_cooldown:
		target = attackPlayerZone.player.global_position
		Enemy.disable_detection(self)
		attacking = true
		$DelayTimer.start()
		yield($DelayTimer, "timeout")
		hitbox.set_deferred("monitorable", true)
		eye.modulate = Color(1,0,0)
		attackTimer.start()
		state = ATTACK

func _on_AttackTimer_timeout():
	attack_on_cooldown = true
	hitbox.set_deferred("monitorable", false)
	eye.modulate = Color(0,0,0)
	state = IDLE
	timer.start()
	yield(timer, "timeout")
	if attack_on_cooldown:
		attack_on_cooldown = false
		Enemy.enable_detection(self)

func update_wander_state():
	state = IDLE
	return
# warning-ignore:unreachable_code
	state = pick_random_state([IDLE, WANDER]) # feeds an array with the IDLE and WANDER states as its argument
	wanderController.start_wander_timer(rand_range(1, 3)) # starts wander timer between 1s & 3s

func pick_random_state(state_list): 
	state_list.shuffle() # shuffles the order of the list of states recieved
	return state_list.pop_front() # spits one out

func create_hit_effect(_damage_count):
	pass

func _on_Hurtbox_area_entered(area): # runs when a hitbox enters the bat's hurtbox
	if area.get("formula") or area.get_parent().get_parent().dying: return
	var facing_direction = area.get_parent().get_parent().dir_vector
	get_node("/root/World/").fade_out()
	$Timer.start(0.8)
	yield($Timer, "timeout")
	print('changing scene')
	var new_inventory = [get_node("/root/World/YSort/Player").inventory, get_node("/root/World/YSort/Player").pouch, get_node("/root/World/YSort/Player").formulabook]
	Global.goto_scene("res://assets/Maps/Test/Space.tscn", {"direction": facing_direction, "location":Vector2(320,580), "inventory":new_inventory})
	var hit = Enemy.hurtbox_entered(self, area)
	if hit && state == ATTACK:
		state = IDLE

func _on_BatStats_no_health():
	var death_effect = EnemyDeathEffect.instance()
	Enemy.no_health(self, death_effect)
	# sprite.playing = false # stop animation
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
