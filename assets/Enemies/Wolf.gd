extends KinematicBody2D

const EnemyDeathEffect = preload("res://assets/Effects/EnemyDeathEffect.tscn")
const ExpNotice = preload("res://assets/UI/ExpNotice.tscn")
const DialogBox = preload("res://assets/UI/DialogBox.tscn")
const HeartPickup = preload("res://assets/ItemDrops/HeartPickup.tscn")
const PennyPickup = preload("res://assets/ItemDrops/PennyPickup.tscn")
const HealingPotion = preload("res://assets/ItemsInventory/Healing_Potion.tscn")
var EnemySpawner = load("res://assets/Spawners/EnemySpawner.tscn")

const ENEMY_NAME = "Wolf"
export var ACCELERATION = 800
export var MAX_SPEED = 40
export var WANDER_SPEED = 40
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

var velocity = Vector2.ZERO
# var dir_vector = Vector2.DOWN
var knockback = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var random_number

var interactable = false
var talkable = false
var examined = false
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
# warning-ignore:return_value_discarded
	PlayerLog.connect("wolf_complete", self, "examine_complete")
	if PlayerLog.wolf_examined:
		examined = true
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
				target = player.global_position
				audio_attack()
				# attack_animation()
				
			accelerate_towards_point(target, ATTACK_SPEED, delta)
			if global_position.distance_to(target) <= ATTACK_TARGET_RANGE:
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
	idle_animation()

func examine():
	var dialogBox = DialogBox.instance()
	dialogBox.dialog_script = [
		{'text': "A common wolf. It looks friendly."},
		{'text': "Though it's probably safe to assume that it isn't."}
	]
	get_node("/root/World/GUI").add_child(dialogBox)
	if !examined:
		examined = true
		PlayerLog.wolf_examined = true
		PlayerLog.set_examined("wolf", true)

func examine_complete(value):
	examined = value
			
func accelerate_towards_point(point, speed, delta):
	var direction = global_position.direction_to(point) # gets the direction by grabbing the target position, the point argument
	velocity = velocity.move_toward(direction * speed, ACCELERATION * delta) # multiplies that by the speed argument
	h_flip_handler()

func seek_player():
	if hitbox.monitorable:
		hitbox.set_deferred("monitorable", false)
	if playerDetectionZone.can_see_player() && !attacking:
		# attack_animation()
		audio_detect()
		eye.modulate = Color(1,0.8,0)
		eye.frame = sprite.frame
		state = CHASE

func attack_player():
	if attackPlayerZone.can_attack_player() && !attack_on_cooldown:
		disable_detection()
		attacking = true
		$DelayTimer.start()
		yield($DelayTimer, "timeout")
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
	timer.start()
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

func update_wander_state():
	if abs(global_position.x - player.global_position.x) > 320 || abs(global_position.y - player.global_position.y) > 180:
		print('too far: deleting wolf')
		queue_free()
		
		var newEnemySpawner = EnemySpawner.instance()
		get_parent().call_deferred("add_child", newEnemySpawner)
		newEnemySpawner.ENEMY = load("res://assets/Enemies/Wolf.tscn")
		newEnemySpawner.global_position = global_position

	else:
		state = pick_random_state([IDLE, WANDER]) # feeds an array with the IDLE and WANDER states as its argument
		var state_rng = rand_range(2, 4)
		if state == 0: # IDLE STATE
			if state_rng > 3: # plays animation 25% of the time
				pass
			else:
				pass # otherwise plays the idle animation
		elif state == 1: # WANDER STATE
			pass
			# fly_animation()
		
		h_flip_handler()
		wanderController.start_wander_timer(state_rng) # starts wander timer between 2s & 4s
		
func pick_random_state(state_list): 
	state_list.shuffle() # shuffles the order of the list of states recieved
	return state_list.pop_front() # spits one out

func _on_Hurtbox_area_entered(area):
	var evasion_mod = 0
	var hit = Global.player_hit_calculation(PlayerStats.base_accuracy, PlayerStats.dexterity, PlayerStats.dexterity_mod, stats.evasion+evasion_mod)
	if !hit:
		SoundPlayer.play_sound("miss")
		hurtbox.display_damage_popup("Miss!", false)
	else:
		var is_crit = Global.crit_calculation(PlayerStats.base_crit_rate, PlayerStats.dexterity, PlayerStats.dexterity_mod)
		var damage = Global.damage_calculation(area.damage, stats.defense, area.randomness)
		if is_crit:
			damage *= 2
		stats.health -= damage
		audio_hit()
		hurtbox.display_damage_popup(str(damage), is_crit)
		hurtbox.create_hit_effect()
		hurtbox.start_invincibility(0.3)
		$EnemyHealth.show_health()
		# state = IDLE
#		disable_detection()
#		timer.start(0.4)
#		yield(timer, "timeout")
#		enable_detection()
		
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

func _on_WolfStats_no_health():
	# sprite.playing = false # stop animation
	hurtbox.set_deferred("monitoring", false) # turn off hurtbox
	hitbox.set_deferred("monitorable", false)
	animationPlayer.stop()
	state = DEAD
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
	player.enemy_killed(stats.experience_pool)
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	# enemyDeathEffect.enemy = ENEMY_NAME
	enemyDeathEffect.global_position = global_position
	
	var expNotice = ExpNotice.instance()
	expNotice.position = global_position
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

func audio_detect():
	audio.stream = load("res://assets/Audio/Enemies/Wolf_Growl_1.wav")
	audio.play()

func audio_attack():
	audio.stream = load("res://assets/Audio/Enemies/Wolf_Attack_1.wav")
	audio.play()

func audio_hit():
	audio.stream = load("res://assets/Audio/Enemies/Wolf_Hit_1.wav")
	audio.play()
