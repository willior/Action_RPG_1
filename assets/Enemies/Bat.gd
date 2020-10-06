extends KinematicBody2D

const EnemyDeathEffect = preload("res://assets/Effects/EnemyDeathEffect.tscn")
const ExpNotice = preload("res://assets/UI/ExpNotice.tscn")
const DialogBox = preload("res://assets/UI/Dialog.tscn")
const HeartPickup = preload("res://assets/Items/HeartPickup.tscn")
const PennyPickup = preload("res://assets/Items/PennyPickup.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 40
export var WANDER_SPEED = 20
export var ATTACK_SPEED = 200
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

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var random_number

var state = IDLE
var interactable = false
var talkable = false
var examined = false
var attacking = false
var attack_on_cooldown = false
var target
var facingLeft = false

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
onready var talkBox = $BatTalkBox/CollisionShape2D
onready var player = get_parent().get_parent().get_node("Player")

func _ready():
	add_to_group("enemies")
	rng.randomize()
	random_number = rng.randi_range(0, 4)
	sprite.frame = random_number
	eye.frame = random_number
	set_speed_scale(1)
	sprite.playing = true
	eye.playing = true
	
	# turn off playerDetectionZone and attackPlayerZone:
	# attackPlayerZone.set_deferred("monitoring", false)
	# playerDetectionZone.set_deferred("monitoring", false)
	
	# turn off hitbox:
	# hitbox.set_deferred("monitorable", false)
	
func set_speed_scale(value):
	sprite.speed_scale = value
	eye.speed_scale = value

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
				target = player.global_position
				attacking = false
			accelerate_towards_point(target, ATTACK_SPEED, delta)
			if global_position.distance_to(player.global_position) <= ATTACK_TARGET_RANGE:
				sprite.speed_scale = 1
				state = IDLE
		DEAD:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
				
	sprite.flip_h = velocity.x < 0
	eye.flip_h = velocity.x < 0
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
		
	velocity = move_and_slide(velocity)
	
func examine():
	var dialogBox = DialogBox.instance()
	dialogBox.dialog = [
		"Bats are mammals of the Chiroptera order.",
		"They are the only mammals capable of true and sustained flight."
	]
	get_node("/root/World/GUI").add_child(dialogBox)
	player.talkTimer.start()
	if !examined: examined = true
			
func accelerate_towards_point(point, speed, delta):
	var direction = global_position.direction_to(point) # gets the direction by grabbing the target position, the point argument
	velocity = velocity.move_toward(direction * speed, ACCELERATION * delta) # multiplies that by the speed argument

func seek_player():
	if playerDetectionZone.can_see_player() && !attacking:
		set_speed_scale(2)
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
		disable_detection()
		attackTimer.start()
		attacking = true
		hitbox.set_deferred("monitorable", true)
		set_speed_scale(4)
		eye.modulate = Color(1,0,0)
		state = ATTACK
		
func _on_AttackTimer_timeout():
	attack_on_cooldown = true
	hitbox.set_deferred("monitorable", false)
	set_speed_scale(1)
	eye.modulate = Color(0,0,0)
	state = IDLE
	timer.start(1)
	yield(timer, "timeout")
	if attack_on_cooldown:
		attack_on_cooldown = false
		enable_detection()
	
func disable_detection():
	attackPlayerZone.set_deferred("monitoring", false)
	playerDetectionZone.set_deferred("monitoring", false)
	
func enable_detection():
	attackPlayerZone.set_deferred("monitoring", true)
	playerDetectionZone.set_deferred("monitoring", true)
		
func attack_start():
	pass
		
func attack_finished():
	pass
		
func update_wander_state():
	state = pick_random_state([IDLE, WANDER]) # feeds an array with the IDLE and WANDER states as its argument
	wanderController.start_wander_timer(rand_range(1, 3)) # starts wander timer between 1s & 3s
		
func pick_random_state(state_list): 
	state_list.shuffle() # shuffles the order of the list of states recieved
	return state_list.pop_front() # spits one out

func _on_Hurtbox_area_entered(area): # runs when a hitbox enters the bat's hurtbox
	if attack_on_cooldown:
		attack_on_cooldown = false
		timer.stop()
		enable_detection()
	stats.health -= area.damage # does damage equal to the variable exported by the sword hitbox's script
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)
	
	sprite.modulate = Color(1,1,0)
	if stats.health > 0:
		knockback = area.knockback_vector * 120 # knockback velocity
		tween.interpolate_property(sprite,
		"modulate",
		Color(1, 1, 0),
		Color(1, 1, 1),
		0.2,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
		)
		tween.start()
	else:
		knockback = area.knockback_vector * 200 # knockback velocity on killing blow

func _on_BatStats_no_health():
	sprite.playing = false # stop animation
	hurtbox.set_deferred("monitoring", false) # turn off hurtbox
	hitbox.set_deferred("monitorable", false)
	state = DEAD
	
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
	
	tween.interpolate_property(sprite,
	"modulate",
	Color(1, 1, 0),
	Color(1, 0, 0),
	0.5,
	Tween.TRANS_LINEAR,
	Tween.EASE_IN
	)
	tween.start()
	
	timer.start(0.5)
	yield(timer, "timeout")
	
	player.enemy_killed(stats.experience_pool)
	
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	
	var expNotice = ExpNotice.instance()
	expNotice.rect_position = global_position
	expNotice.expDisplay = stats.experience_pool
	
	get_node("/root/World").add_child(expNotice)
	
	if player.stats.health < player.stats.max_health && randi() % 2 == 1:
		var heartPickup = HeartPickup.instance()
		heartPickup.global_position = global_position
		get_node("/root/World/YSort/Items").add_child(heartPickup)
		
	if randi() % 2 == 1:
		var pennyPickup = PennyPickup.instance()
		pennyPickup.global_position = global_position
		get_node("/root/World/YSort/Items").add_child(pennyPickup)
	
	queue_free()

func _on_Hurtbox_invincibility_started():
	animationPlayer.play("StartFlashing")

func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("StopFlashing")

func _on_BatTalkBox_area_entered(_area):
	interactable = true
	# player.interacting = true

func _on_BatTalkBox_area_exited(_area):
	interactable = false
	# player.interacting = false
