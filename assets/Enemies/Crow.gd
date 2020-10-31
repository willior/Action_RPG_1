extends KinematicBody2D

const EnemyDeathEffect = preload("res://assets/Effects/Crow_DeathEffect.tscn")
const ExpNotice = preload("res://assets/UI/ExpNotice.tscn")
const DialogBox = preload("res://assets/UI/Dialog.tscn")
const HeartPickup = preload("res://assets/ItemDrops/HeartPickup.tscn")
const PennyPickup = preload("res://assets/ItemDrops/PennyPickup.tscn")
const HealingPotion = preload("res://assets/ItemsInventory/Healing_Potion.tscn")

const ENEMY_NAME = "Crow"
export var ACCELERATION = 200
export var MAX_SPEED = 400
export var WANDER_SPEED = 80
export var ATTACK_SPEED = 6000
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
onready var player = get_parent().get_parent().get_node("Player")

func _ready():
	add_to_group("enemies")
	# rng.randomize()
	# random_number = rng.randi_range(0, 4)
	animationTree.active = true

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
				state = IDLE

		ATTACK:
			if attacking:
				target = player.global_position
				attacking = false
				audio_cawcawcaw()
				fly_animation()
				
			accelerate_towards_point(target, ATTACK_SPEED, delta)
			if global_position.distance_to(player.global_position) <= ATTACK_TARGET_RANGE:
				state = IDLE
		DEAD:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
		
	velocity = move_and_slide(velocity)
	
func h_flip_handler():
	if velocity.x < 0:
		sprite.flip_h = true
		eye.flip_h = true
	else:
		sprite.flip_h = false
		eye.flip_h = false
	
func examine():
	var dialogBox = DialogBox.instance()
	dialogBox.dialog = [
		"A common crow.",
		"Except that it's over-sized. And more aggressive than usual, to say the least."
	]
	get_node("/root/World/GUI").add_child(dialogBox)
	if !examined: examined = true
			
func accelerate_towards_point(point, speed, delta):
	if flying:
		var direction = global_position.direction_to(point) # gets the direction by grabbing the target position, the point argument
		velocity = velocity.move_toward(direction * speed, ACCELERATION * delta) # multiplies that by the speed argument
		h_flip_handler()

func seek_player():
	if playerDetectionZone.can_see_player() && !attacking:
		# animationState.travel("Fly")
		fly_animation()
		eye.modulate = Color(1,0.8,0)
		state = CHASE

func attack_player():
	if attackPlayerZone.can_attack_player() && !attack_on_cooldown:
		disable_detection()
		attackTimer.start()
		attacking = true
		# hitbox.set_deferred("monitorable", true)
		eye.modulate = Color(1,0,0)
		state = ATTACK
		
func _on_AttackTimer_timeout():
	attack_on_cooldown = true
	# hitbox.set_deferred("monitorable", false)
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
	var state_rng = rand_range(2, 4)
	if state == 0: # IDLE STATE
		if state_rng > 3: # plays the "Peck" animation 25% of the time
			animationState.travel("Peck")
		else:
			animationState.travel("Idle") # otherwise plays the idle animation
	elif state == 1: # WANDER STATE
		# animationState.travel("Fly")
		fly_animation()
	
	# h_flip_handler()
	wanderController.start_wander_timer(state_rng) # starts wander timer between 2s & 4s
		
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
	# enemyDeathEffect.enemy = ENEMY_NAME
	enemyDeathEffect.global_position = global_position
	
	var expNotice = ExpNotice.instance()
	expNotice.rect_position = global_position
	expNotice.expDisplay = stats.experience_pool
	
	get_node("/root/World").add_child(expNotice)
	
	if randi() % 2 == 1:
		var healingPotion = HealingPotion.instance()
		get_node("/root/World/YSort/Items").call_deferred("add_child", healingPotion)
		healingPotion.global_position = global_position
	
	elif player.stats.health < player.stats.max_health && randi() % 2 == 1:
		var heartPickup = HeartPickup.instance()
		get_node("/root/World/YSort/Items").call_deferred("add_child", heartPickup)
		heartPickup.global_position = global_position
		
	elif randi() % 2 == 1:
		var pennyPickup = PennyPickup.instance()
		get_node("/root/World/YSort/Items").call_deferred("add_child", pennyPickup)
		pennyPickup.global_position = global_position

	queue_free()

func idle_animation():
	animationState.travel("Idle")
	
func fly_animation():
	animationState.travel("Fly")
	
func set_flying(value):
	flying = value
	
func audio_caw():
	audio.stream = load("res://assets/Audio/Crow_caw.wav")
	audio.play()
	
func audio_cawcawcaw():
	audio.stream = load("res://assets/Audio/Crow_cawcawcaw.wav")
	audio.play()
