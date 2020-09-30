extends KinematicBody2D

const EnemyDeathEffect = preload("res://assets/Effects/EnemyDeathEffect.tscn")
const ExpNotice = preload("res://assets/UI/ExpNotice.tscn")
const DialogBox = preload("res://assets/UI/Dialog.tscn")
const HeartPickup = preload("res://assets/Items/HeartPickup.tscn")
const PennyPickup = preload("res://assets/Items/PennyPickup.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 40
export var WANDER_SPEED = 20
export var FRICTION = 240
export var WANDER_TARGET_RANGE = 4

enum {
	IDLE,
	WANDER,
	CHASE,
	DEAD
}

var rng = RandomNumberGenerator.new()
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = IDLE
var interactable = false

onready var stats = $BatStats
onready var timer = $Timer
onready var sprite = $AnimatedSprite
onready var tween = $Tween
onready var hitbox = $Hitbox
onready var hurtbox = $Hurtbox
onready var playerDetectionZone = $PlayerDetectionZone
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer
onready var talkBox = $BatTalkBox/CollisionShape2D
onready var player = get_parent().get_node("Player")

func _ready():
	add_to_group("enemies")
	rng.randomize()
	sprite.frame = rng.randi_range(0, 4)
	sprite.speed_scale = 1

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
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, MAX_SPEED, delta) # gets the direction by comparing the enemy position with the player's
			else:
				sprite.speed_scale = 1
				state = IDLE
				
		DEAD:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
				
	sprite.flip_h = velocity.x < 0
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
		
	velocity = move_and_slide(velocity)
	
	if (interactable && Input.is_action_pressed("examine") && player.talkTimer.is_stopped()):
		# talkBox.disabled = true
		var dialogBox = DialogBox.instance()
		dialogBox.dialog = [
			"Bats are mammals of the Chiroptera order.",
			"They are the only mammals capable of true and sustained flight."
		]
		get_node("/root/World/GUI").add_child(dialogBox)
		player.talkTimer.start()
			
func accelerate_towards_point(point, speed, delta):
	var direction = global_position.direction_to(point) # gets the direction by grabbing the target position in the WanderController
	velocity = velocity.move_toward(direction * speed, ACCELERATION * delta) # multiplies that by the WANDER_SPEED value

func seek_player():
	if playerDetectionZone.can_see_player():
		sprite.speed_scale = 2
		state = CHASE
		
func update_wander_state():
	state = pick_random_state([IDLE, WANDER]) # feeds an array with the IDLE and WANDER states as its argument
	wanderController.start_wander_timer(rand_range(1, 3))
		
func pick_random_state(state_list): 
	state_list.shuffle() # shuffles the order of the list of states recieved
	return state_list.pop_front() # spits one out

func _on_Hurtbox_area_entered(area): # runs when a hitbox enters the bat's hurtbox
	stats.health -= area.damage # does damage equal to the variable exported by the sword hitbox's script
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)
	prints(str(area.damage)+" damage")
	
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
	hitbox.queue_free()
	state = DEAD
	
	tween.interpolate_property(sprite,
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
	
	timer.start()
	yield(timer, "timeout")
	
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	
	player.enemy_killed(stats.experience_pool)
	
	var expNotice = ExpNotice.instance()
	expNotice.rect_position = global_position
	expNotice.expDisplay = stats.experience_pool
	
	get_node("/root/World").add_child(expNotice)
	
	if player.stats.health < player.stats.max_health && randi() % 2 == 1:
		var heartPickup = HeartPickup.instance()
		heartPickup.global_position = global_position
		get_node("/root/World/YSort").add_child(heartPickup)
		
	if randi() % 2 == 1:
		var pennyPickup = PennyPickup.instance()
		pennyPickup.global_position = global_position
		get_node("/root/World/YSort").add_child(pennyPickup)
	
	queue_free()

func _on_Hurtbox_invincibility_started():
	animationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("Stop")

func _on_BatTalkBox_area_entered(area):
	interactable = true
	# player.interacting = true

func _on_BatTalkBox_area_exited(area):
	interactable = false
	# player.interacting = false
