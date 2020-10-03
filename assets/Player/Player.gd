extends KinematicBody2D

const Notice = preload("res://assets/UI/Notice.tscn")
const LevelNotice = preload("res://assets/UI/LevelNotice.tscn")
const GameOver = preload("res://assets/UI/GameOver.tscn")
const DialogBox = preload("res://assets/UI/Dialog.tscn")

const ACCELERATION = 1600
const MAX_SPEED = 100
const ROLL_SPEED = 200
const SHADE_SPEED = 400
const FRICTION = 800
const SHADE_FRICTION = 1600

enum {
	MOVE,
	ROLL,
	ATTACK1,
	ATTACK2,
	FLASH,
	SHADE,
	HIT
}

enum {
	LEVELHEALTH,
	LEVELSTAMINA,
	LEVELSTRENGTH,
	LEVELSPEED
}

var state = MOVE
var velocity = Vector2.ZERO
var dir_vector = Vector2.DOWN
var roll_moving = false
var damageTaken = 0
var stats = PlayerStats
var levelStats = [0, 1, 2, 3]
var levelResult = 0

var attackIndex = 0
var attack2_queued = false
var attack1_queued = false
var attack_charging = false
var attack_1_charged = false
var attack_2_charged = false
var shade_moving = false
var charge_count = 0
var charge_level_count = 0

var interacting = false
var talking = false
var dying = false

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var actionHitbox = $HitboxPivot/ActionHitbox/CollisionShape2D
onready var hurtbox = $Hurtbox
onready var collision = $Hurtbox/CollisionShape2D
onready var collect = $Collectbox
onready var timer = $Timer
onready var talkTimer = $TalkTimer
onready var notice = $Notice
onready var charge = $ChargeUI
onready var charge1Vis = $ChargeUI/TextureProgress1
onready var charge2Vis = $ChargeUI/TextureProgress2

func _ready():
	stats.connect("no_health", self, "game_over")
	animationTree.active = true # animation not active until game starts
	swordHitbox.knockback_vector = dir_vector / 4
	collision.disabled = false
	charge1Vis.visible = false
	charge2Vis.visible = false

func _process(delta):
	if interacting:
		notice.visible = true
	else:
		notice.visible = false
	
	match state:
		MOVE:
			attackIndex = 0
			move_state(delta)
		ROLL: roll_state()
		ATTACK1: attack1_state(delta)
		ATTACK2: attack2_state(delta)
		SHADE: shade_state(delta)
		FLASH: flash_state(delta)
		HIT: hit_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength ("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	stats.stamina += 0.5
	
	# if player is moving
	if input_vector != Vector2.ZERO:
		dir_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack1/blend_position", input_vector)
		animationTree.set("parameters/Attack2/blend_position", input_vector)
		animationTree.set("parameters/Shade/blend_position", input_vector)
		animationTree.set("parameters/Flash/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationTree.set("parameters/Hit/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("examine"):
		if !interacting && talkTimer.is_stopped():
			var dialogBox = DialogBox.instance()
			dialogBox.dialog = [
			"You find nothing of interest."
			]
			get_node("/root/World/GUI").add_child(dialogBox)
			talkTimer.start()

	if Input.is_action_just_pressed("attack"):
		if !talking && stats.stamina > 0:
			state = ATTACK1
		elif stats.stamina <= 0:
			noStamina()
			
	elif Input.is_action_pressed("attack"):
		if charge_count == 0:
			if charge_level_count == 0:
				charge.begin_charge_1()
				
			elif charge_level_count == 1:
				charge.begin_charge_2()
				
		charge_state(delta)
			
	if Input.is_action_just_released("attack"):
		charge.stop_charge()
		attack_charging = false
		if attack_1_charged:
			attack_1_charged = false
			state = FLASH
		if attack_2_charged:
			attack_2_charged = false
			state = SHADE
		
	if Input.is_action_just_pressed("roll"):
		charge.stop_charge()
		#if attack_2_charged:
		#	attack_2_charged = false
		#	shade_moving = true
		#	state = SHADE
		if stats.stamina > 0:
			if input_vector != Vector2.ZERO:
				roll_moving = true
				state = ROLL
			else:
				print('backstep')
		else:
			#$AudioStreamPlayer.stream = load("res://assets/Audio/Bamboo.wav")
			#$AudioStreamPlayer.play()
			noStamina()
		
func move():
	velocity = move_and_slide(velocity)
	
func noStamina():
	$AudioStreamPlayer.stream = load("res://assets/Audio/Bamboo.wav")
	$AudioStreamPlayer.play()
	
# 1st attack pressed: state switches to attack1, plays attack1
# 2nd attack pressed: attack2_queued becomes true
# on attack1_animation_finished, checks attack2_queued
# if true, plays attack2; attack2_queued becomes false
# 3rd attack pressed: attack1_queued becomes true
# on attack2_animation_finished, checks attack1_queued
# if true, plays attack1; attack1_queued becomes false, etc.
func attack1_state(delta):
# warning-ignore:integer_division
	velocity = velocity.move_toward(Vector2.ZERO, (FRICTION/2) * delta)
	if attack2_queued == false:
		animationState.travel("Attack1")
	if Input.is_action_just_pressed("attack"):
		if stats.stamina <= 0:
			noStamina()
		else:
			attack2_queued = true
	move()
	
# warning-ignore:unused_argument
func attack2_state(delta):
	if attack2_queued == false:
		animationState.travel("Attack2")
	if Input.is_action_just_pressed("attack"):
		if stats.stamina <= 0:
			noStamina()
		else:
			attack1_queued = true
		
func attack1_stamina_drain():
	stats.stamina -= 10
	
func attack2_stamina_drain():
	stats.stamina -= 5

func attack_animation_finished():
	if attack2_queued:
		attack2_queued = false
		state = ATTACK2
	elif attack1_queued:
		attack1_queued = false
		state = ATTACK1
	else: state = MOVE

	if Input.is_action_pressed("attack"):
		attack_charging = true
		charge_count = 0
		charge_level_count = 0
	
# when an attack animation finishes, checks to see if the button is still held
# if it is, changes the player state to "charging"
# if the player releases the attack button, charging state ends
# if the player holds the button for enough time, charge_level_1 is achieved
# if the player continues to hold the button, charge_level_2 is achieved

# warning-ignore:unused_argument
func charge_state(delta):
	stats.stamina -= 0.5
	if attack_1_charged:
		if stats.stamina <= 0:
			attack_1_charged = false
			charge.stop_charge()
			charge_count = 0
			stats.charge = charge_count
			
	if charge_count < PlayerStats.max_charge:
		charge_count += 1
		stats.charge = charge_count
		
	elif charge_count == PlayerStats.max_charge:
		attack_1_charged = true
		

# charge stage
# drains stamina
# checks if either attack 1 or 2 is charged
func charge_state_new(delta):
	stats.stamina -= 0.5
	if (attack_1_charged || attack_2_charged) && stats.stamina <= 0:
		attack_charging = false
		attack_1_charged = false
		attack_2_charged = false
		charge.stop_charge()
		charge_count = 0
		charge_level_count = 0
		stats.charge = charge_count
		stats.charge_level = charge_level_count
			
	elif charge_count < PlayerStats.max_charge:
		charge_count += 1
		stats.charge = charge_count
		
	elif charge_count == PlayerStats.max_charge:
		if charge_level_count == 0:
			attack_1_charged = true
			charge_level_count = 1
			stats.charge_level = charge_level_count
			
			charge_count = 0
			stats.charge = charge_count
			print('attack 1 charged!')
			
		elif charge_level_count == 1:
			attack_2_charged = true
			charge_level_count = 2
			stats.charge_level = charge_level_count
			
			charge_count = 0
			stats.charge = charge_count
			print('attack 2 charged!')
		
	elif charge_level_count == PlayerStats.max_charge_level:
		print('max charge')
		
func shade_state(delta):
	if shade_moving:
# warning-ignore:integer_division
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION/3 * delta)
	else:
		if Input.is_action_just_pressed("attack"):
			attack2_queued = true
	animationState.travel("Shade")
	move()
	
func shade_start():
	stats.stamina -= 30
	charge.stop_charge()
	swordHitbox.shade_begin()
	PlayerStats.strength_mod = 4
	velocity = dir_vector * SHADE_SPEED
	
func shade_stop():
	swordHitbox.shade_end()
	PlayerStats.strength_mod = 0
	velocity = Vector2.ZERO
	shade_moving = false
	
func flash_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION/3 * delta)
	animationState.travel("Flash")
	
func flash_start():
	stats.stamina -= 20
	charge.stop_charge()
	swordHitbox.flash_begin()
	PlayerStats.strength_mod = 2
	
func flash_stop():
	swordHitbox.flash_end()
	PlayerStats.strength_mod = 0
	
func enemy_killed(experience_from_kill):
	stats.experience += experience_from_kill
	stats.experience_total += experience_from_kill
	
	while stats.experience >= stats.experience_required:
		level_up()
		stats.experience -= stats.experience_required
		stats.experience_required *= 1.618034
	
func level_up():
	stats.level += 1
	var levelNotice = LevelNotice.instance()
	levelNotice.rect_position = global_position
	levelNotice.levelDisplay = stats.level
	var choice = levelStats[randi() % levelStats.size()]
	match choice:
		LEVELHEALTH:
			stats.max_health += 1
			stats.health += 1
			levelNotice.statDisplay = "WILLPOWER"
			levelNotice.statColor = Color(1, 0.272549, 0.315686)
		LEVELSTAMINA:
			stats.max_stamina += 15
			levelNotice.statDisplay = "PERSEVERENCE"
			levelNotice.statColor = Color(0.372549, 1, 0.415686)
		LEVELSTRENGTH:
			stats.strength += 1
			levelNotice.statDisplay = "VIOLENT NATURE"
			levelNotice.statColor = Color(0.254902, 0.372549, 0.415686)
		LEVELSPEED:
			stats.iframes += 0.1
			stats.speed += 1
			var totalSpeed = animationPlayer.get_playing_speed() + stats.speed

			levelNotice.statDisplay = "SWIFTNESS"
			levelNotice.statColor = Color(1, 1, 0.415686)
	# prints('LEVEL ' + str(stats.level) + ":")
	# prints("max_health = " + str(stats.max_health))
	# prints("max_stamina = " + str(stats.max_stamina))
	# prints("max_strength = " + str(stats.strength))
	# prints("max_speed = " + str(stats.iframes))
	get_node("/root").add_child(levelNotice)
	
func roll_stamina_drain():
	stats.stamina -= 15
	if hurtbox.timer.is_stopped(): 
		hurtbox.start_invincibility(stats.iframes)
	else:
		pass
		
func roll_state():
	if roll_moving:
			velocity = dir_vector * ROLL_SPEED
	else:
# warning-ignore:integer_division
		velocity = dir_vector * (ROLL_SPEED/4)
	animationState.travel("Roll")
	move()

func roll_stop():
	roll_moving = false
	
func roll_animation_finished():
	state = MOVE
	if Input.is_action_pressed("attack"):
		attack_charging = true
		# charge_count = 0
		# stats.charge = charge_count
	
func _on_Hurtbox_area_entered(area):
	if attack2_queued: attack2_queued = false
	if attack_charging: attack_charging = false
	if attack_1_charged: attack_1_charged = false
	if attack_2_charged: attack_2_charged = false
	if charge_count > 0: charge_count = 0
	if charge_level_count > 0: charge_level_count = 0
	damageTaken = area.damage
	state = HIT
	
func hit_damage():
	PlayerStats.strength_mod = 0
	stats.health -= damageTaken
	hurtbox.start_invincibility(1)
	hurtbox.create_hit_effect()
	
func hit_state(delta):
	velocity = -dir_vector * (ROLL_SPEED/2)
	animationState.travel("Hit")
	move()
	
func hit_animation_finished():
	state = MOVE
	if Input.is_action_pressed("attack"):
		attack_charging = true
		charge_count = 0
		stats.charge = charge_count

func _on_Hurtbox_invincibility_started():
	# sprite.modulate = Color(0,1,1,1)
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	# sprite.modulate = Color(1,1,1,1)
	blinkAnimationPlayer.play("Stop")
	
func game_over():
	dying = true
	get_node("/root/World/Music").stream_paused = true
	var gameOver = GameOver.instance()
	get_node("/root/World/GUI").add_child(gameOver)
	get_node("/root/World/GUI/HealthUI").visible = false
	get_node("/root/World/GUI/ExpBar").visible = false
	get_node("/root/World/GUI/StaminaBar").visible = false
	self.visible = false
	get_tree().paused = true

func _on_TalkTimer_timeout():
	actionHitbox.disabled = false
