extends KinematicBody2D

const Notice = preload("res://assets/UI/Notice.tscn")
const GameOver = preload("res://assets/UI/GameOver.tscn")
const DialogBox = preload("res://assets/UI/DialogBox.tscn")
const LevelUpScreen = preload("res://assets/UI/LevelUp/LevelUpScreen.tscn")
const TweenGreyscale = preload("res://assets/Shaders/Greyscale_TweenCanvasModulate.tscn")
const Greyscale = preload("res://assets/Shaders/Greyscale_CanvasModulate.tscn")
const RedFlash = preload("res://assets/Shaders/Red_CanvasModulate.tscn")
const Heartbeat = preload("res://assets/Audio/SFX/Heartbeat.tscn")
const MessagePopup = preload("res://assets/UI/Popups/MessagePopup.tscn")

var inventory_resource = load("res://assets/Player/Inventory.gd")
var inventory = inventory_resource.new()
var pouch_resource = load("res://assets/Player/Pouch.gd")
var pouch = pouch_resource.new()
var formulabook_resource = load("res://assets/Player/FormulaBook.gd")
var formulabook = formulabook_resource.new()
var ingredient1_OK : bool
var ingredient2_OK : bool

enum {
	MOVE,
	ROLL,
	BACKSTEP,
	ATTACK1,
	ATTACK2,
	FLASH,
	SHADE,
	HIT,
	PICKUP,
	ACTION,
	STUN
}

var state = MOVE
var velocity = Vector2.ZERO
var dir_vector = PlayerStats.dir_vector
var damageTaken = 0
var stats = PlayerStats
var stamina_regen_level = 0
var levelStats = [0, 1, 2, 3, 4, 5]
var levelResult = 0

var level_queued = false
var queued_levels = 0
var levels_to_add = 0
var stats_to_allocate = 0

var roll_moving = false
var backstep_moving = false
var backstep_queued = false
var attack2_queued = false
var attack1_queued = false
var attack_charging = false
var attack_1_charged = false
var attack_2_charged = false
var flash_queued = false
var shade_queued = false
var shade_moving = false
var charge_count = 0
var charge_level_count = 0
var base_enemy_accuracy = 66

var interactObject
var talkObject
var examining = false
var talking = false
var interacting = false
var using_item = false
var casting = false

var noticeDisplay = false setget set_notice
var talkNoticeDisplay = false setget set_talk_notice
var interactNoticeDisplay = false setget set_interact_notice
var sweating = false
var dying = false
var just_leveled = 0

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var interactHitbox = $HitboxPivot/InteractHitbox/CollisionShape2D
onready var hurtbox = $Hurtbox
onready var collision = $Hurtbox/CollisionShape2D
onready var collect = $Collectbox
onready var timer = $Timer
onready var talkTimer = $TalkTimer
onready var notice = $ExamineNotice
onready var talkNotice = $TalkNotice
onready var interactNotice = $InteractNotice
onready var charge = $ChargeUI
onready var bamboo = $BambooAudio

signal player_saved

func _ready():
	if Global.get_attribute("location") != null:
		position = Global.get_attribute("location")
	if Global.get_attribute("direction") != null:
		dir_vector = Global.get_attribute("direction")
		reset_animation()
#	if Global.get_attribute("inventory") != null:
#		inventory.set_items(Global.get_attribute("inventory").get_items())
#		inventory.items_set = false
#		GameManager.reinitialize_player(inventory)
#	else: GameManager.initialize_player()
	Global.update_player()
	animationTree.active = true # animation not active until game starts
	swordHitbox.knockback_vector = dir_vector / 4
	collision.disabled = false
	charge_reset()
	stats.connect("status_changed", self, "apply_status")
	stats.connect("player_dying", self, "dying_effect")
	stats.connect("no_health", self, "game_over")
	stats.connect("attack_speed_changed", self, "set_attack_timescale")
	set_attack_timescale(Player2Stats.attack_speed)
	Player2Stats.status = "default_speed"

func _process(delta):
	match state:
		MOVE: move_state(delta)
		ROLL: roll_state(delta)
		BACKSTEP: backstep_state(delta)
		ATTACK1: attack1_state(delta)
		ATTACK2: attack2_state(delta)
		SHADE: shade_state(delta)
		FLASH: flash_state(delta)
		HIT: hit_state(delta)

func _input(event):
	match state:
		MOVE:
			if event.is_action_pressed("attack_2") && !event.is_echo():
				if (!talking && !interacting) && stats.stamina > 0:
					state = ATTACK1
				elif interacting && interactObject.interactable && !dying:
					talkTimer.start()
					interactObject.interact()
					if examining:
						self.noticeDisplay = false
				elif talking && interactObject.talkable && talkTimer.is_stopped() && !dying:
					talkTimer.start()
					interactObject.talk()
				elif stats.stamina <= 0:
					noStamina()
					
#			if event.is_action_pressed("item_2"): # G
#				var item_used = player1.inventory._items[player1.inventory.current_selected_item]
#				match item_used.item_reference.type:
#					0: # CONSUMABLE
#						player1.inventory.use_item(2)
#					1: # TOOL
#						pass
#					2: # QUEST
#						if talkTimer.is_stopped() && !dying:
#							if !using_item:
#								talkTimer.start()
#								var dialogBox = DialogBox.instance()
#								dialogBox.dialog_script = [{'text': "Can't use that here."}]
#								get_node("/root/World/GUI").add_child(dialogBox)
#								return
#							else:
#								talkTimer.start()
#								interactObject.use_item_on_object()
		
		ATTACK1:
			if event.is_action_pressed("attack_2") && !event.is_echo():
				if stats.stamina <= 0:
					noStamina()
				else:
					attack2_queued = true
		ATTACK2:
			if event.is_action_pressed("attack_2") && !event.is_echo():
				if stats.stamina <= 0:
					noStamina()
				else:
					attack1_queued = true

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right_2") - Input.get_action_strength ("ui_left_2")
	input_vector.y = Input.get_action_strength("ui_down_2") - Input.get_action_strength("ui_up_2")
	input_vector = input_vector.normalized()
	if sweating:
		stats.stamina += 0.3
		if stats.stamina > 30:
			sweating = false
			$Sweat.visible = false
			stats.status = "sweating_end"
	elif stats.stamina < stats.max_stamina:
		stats.stamina += 0.45

	# if player is moving
	if input_vector != Vector2.ZERO:
		dir_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/BlendSpace2D/blend_position", input_vector)
		animationTree.set("parameters/Attack1/BlendSpace2D/blend_position", input_vector)
		animationTree.set("parameters/Attack2/BlendSpace2D/blend_position", input_vector)
		animationTree.set("parameters/Shade/blend_position", input_vector)
		animationTree.set("parameters/Flash/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationTree.set("parameters/Backstep/blend_position", input_vector)
		animationTree.set("parameters/Hit/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * (stats.max_speed+stats.speed_mod), stats.acceleration * delta)
		if position.x - Global.player1.position.x > 288 or position.x - Global.player1.position.x < -288 or position.y - Global.player1.position.y > 160 or position.y - Global.player1.position.y < -136:
			Global.player1.position = position
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, stats.friction * delta)
		
	move()
	
	if Input.is_action_just_pressed("examine_2"):
		if !dying:
			if !examining && talkTimer.is_stopped():
				talkTimer.start()
				var dialogBox = DialogBox.instance()
				dialogBox.dialog_script = [{'text': "You find nothing of interest."}]
				get_node("/root/World/GUI").add_child(dialogBox)
			elif examining && talkTimer.is_stopped():
				talkTimer.start()
				interactObject.examine()
			
#	if Input.is_action_just_pressed("next_item_2"):
#		player1.inventory.advance_selected_item()
#		interactHitbox.disabled = true
#		interactHitbox.disabled = false
#
#	if Input.is_action_just_pressed("previous_item_2"): # E
#		player1.inventory.previous_selected_item()
#		interactHitbox.disabled = true
#		interactHitbox.disabled = false

	if Input.is_action_pressed("attack_2"):
		if !talkTimer.is_stopped():
			return
		elif charge_count == 0 && charge_level_count == 0 && stats.stamina > 1:
			charge.begin_charge_1()
		elif charge_count == stats.max_charge/2 && charge_level_count == 1:
			charge.begin_charge_2()
		charge_state(delta)
			
	if Input.is_action_just_released("attack_2"):
		if attack_2_charged or stats.charge_level == 2:
			attack_2_charged = false
			state = SHADE
		if attack_1_charged and stats.charge_level == 1:
			attack_1_charged = false
			state = FLASH
		charge.stop_charge()
		charge_reset()
		attack_charging = false
		
	if Input.is_action_just_pressed("roll_2"):
		if stats.stamina > 0:
			if input_vector != Vector2.ZERO:
				roll_moving = true
				state = ROLL
			else:
				backstep_moving = true
				state = BACKSTEP
		else:
			noStamina()
			
func apply_status(status):
	match status:
		"default_speed":
			animationTree.set("parameters/Run/TimeScale/scale", 1)
		"sweating":
			set_sweating()
		"slow":
			animationTree.set("parameters/Run/TimeScale/scale", 0.5)
		"frenzy":
			$FrenzyAnimationPlayer.play("Start")
			# animationTree.set("parameters/Attack1/TimeScale/scale", Player2Stats.attack_speed)
			# animationTree.set("parameters/Attack2/TimeScale/scale", Player2Stats.attack_speed)
		"frenzy_end":
			$FrenzyAnimationPlayer.play("Stop")
			# animationTree.set("parameters/Attack1/TimeScale/scale", Player2Stats.attack_speed)
			# animationTree.set("parameters/Attack2/TimeScale/scale", Player2Stats.attack_speed)

func move():
	if position.x - Global.player1.position.x > 272:
		Global.player1.position.x += 1
		#return
	if position.x - Global.player1.position.x < -272:
		Global.player1.position.x -= 1
		#return
	if position.y - Global.player1.position.y > 136:
		Global.player1.position.y += 1
		#return
	if position.y - Global.player1.position.y < -136:
		Global.player1.position.y -= 1
		#return
	velocity = move_and_slide(velocity)

func noStamina():
	$BambooAudio.play()

func set_sweating():
	$Sweat.visible = true
	sweating = true
	# stats.status = "sweating"
	$ChargeUI/StaminaProgress.visible = false

func set_attack_timescale(value):
	animationTree.set("parameters/Attack1/TimeScale/scale", value)
	animationTree.set("parameters/Attack2/TimeScale/scale", value)

# 1st attack pressed: state switches to attack1, plays attack1
# 2nd attack pressed: attack2_queued becomes true
# on attack1_animation_finished, checks attack2_queued
# if true, plays attack2; attack2_queued becomes false
# 3rd attack pressed: attack1_queued becomes true
# on attack2_animation_finished, checks attack1_queued
# if true, plays attack1; attack1_queued becomes false, etc.
func attack1_state(delta):
# warning-ignore:integer_division
	velocity = velocity.move_toward(Vector2.ZERO, (stats.friction/2) * delta)
	animationState.travel("Attack1")
	move()

# warning-ignore:unused_argument
func attack2_state(delta):
	animationState.travel("Attack2")

func attack1_stamina_drain():
	stats.stamina -= 10
	swordHitbox.sword_attack_audio()
	swordHitbox.set_deferred("monitorable", true)

func attack2_stamina_drain():
	stats.stamina -= 5
	swordHitbox.sword_attack_audio()
	swordHitbox.set_deferred("monitorable", true)

func attack_animation_finished():
	swordHitbox.set_deferred("monitorable", false)
	state = MOVE
	base_enemy_accuracy = 66
	Player2Stats.dexterity_mod = 0
	if attack2_queued:
		attack2_queued = false
		state = ATTACK2
	elif attack1_queued:
		attack1_queued = false
		state = ATTACK1
	elif backstep_queued:
		backstep_queued = false
		backstep_moving = true
		state = BACKSTEP
	else:
		state = MOVE
	# if attack button is held when an attack animation finishes
	if Input.is_action_pressed("attack_2"):
		attack_charging = true
		# charge_reset()

# when an attack animation finishes, checks to see if the button is still held
# if it is, changes the player state to "charging"
# if the player releases the attack button, charging state ends
# if the player holds the button for enough time, charge_level_1 is achieved
# if the player continues to hold the button, charge_level_2 is achieved
# releasing the attack button after achieving a charge level unleashes a special attack
func charge_state(_delta):
	# stamina drain
	stats.stamina -= 0.5
	# if either attack is charged and the player runs out of stamina
	if stats.stamina <= 0:
		if !sweating:
			#set_sweating()
			stats.status = "sweating"
		attack_1_charged = false
		attack_2_charged = false
		charge.stop_charge()
		# noStamina()
		charge_reset()
		
	# if the current charge is less than the max charge
	if charge_count < stats.max_charge:
		charge_count += 2
		stats.charge = charge_count
	# if the charge count reaches 50%
	if charge_count == stats.max_charge/2:
		attack_1_charged = true
	# if the charge count reaches 100%
	elif charge_count == stats.max_charge && attack_charging:
		attack_1_charged = false
		attack_2_charged = true
		attack_charging = false
		
func charge_reset():
	charge_level_count = 0
	stats.charge_level = charge_level_count
	charge_count = 0
	stats.charge = charge_count
		
func shade_state(delta):
	if shade_moving:
# warning-ignore:integer_division
		velocity = velocity.move_toward(Vector2.ZERO, stats.friction/2 * delta)
	else:
		if Input.is_action_just_pressed("attack_2"):
			attack2_queued = true
	animationState.travel("Shade")
	move()
	
func shade_start():
	#set_collision_mask_bit(4, false)
	stats.stamina -= 30
	Player2Stats.dexterity_mod = 8
	charge.stop_charge()
	swordHitbox.shade_begin()
	# stats.strength_mod = 4
	velocity = dir_vector * stats.shade_speed
	
func shade_stop():
	set_collision_mask_bit(4, true)
	$Tween.interpolate_property(
		self,
		"velocity",
		velocity,
		Vector2.ZERO,
		0.2,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
		)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	swordHitbox.shade_end()
	shade_moving = false
	
func flash_state(delta):
	if base_enemy_accuracy > 25:
		base_enemy_accuracy = 25
# warning-ignore:integer_division
	velocity = velocity.move_toward(Vector2.ZERO, stats.friction/2 * delta)
	animationState.travel("Flash")
	move()
	
func flash_start():
	stats.stamina -= 20
	Player2Stats.dexterity_mod = 4
	charge.stop_charge()
	swordHitbox.flash_begin()
	# stats.strength_mod = 2
	
func flash_stop():
	base_enemy_accuracy = 66
	swordHitbox.flash_end()
	# stats.strength_mod = 0
	
func hit_damage():
	stats.health -= damageTaken
	$HurtAudio.play()
	hurtbox.start_invincibility(1)
	hurtbox.create_hit_effect()
	
func hit_state(_delta):
# warning-ignore:integer_division
	velocity = -dir_vector * (stats.roll_speed/2)
	animationState.travel("Hit")
	move()
	
func hit_animation_finished():
	player_state_reset()
	if Input.is_action_pressed("attack_2"):
		attack_charging = true
		charge_reset()
	state = MOVE
	
func player_state_reset():
	swordHitbox.set_deferred("monitorable", false)
	swordHitbox.damage = swordHitbox.orig_damage
	swordHitbox.reset_damage()
	base_enemy_accuracy = 66
	charge.stop_charge()
	# stats.strength_mod = 0
	
func enemy_killed(experience_from_kill):
	stats.experience += experience_from_kill
	stats.experience_total += experience_from_kill
	
	while stats.experience >= stats.experience_required:
		level_up()
		stats.experience -= stats.experience_required
		stats.experience_required *= 1.618034

func level_up():
	just_leveled = true
	stats.level += 1
	if stats.level < 11:
		stats_to_allocate += 2
	elif stats.level < 21:
		stats_to_allocate += 3
	elif stats.level < 31:
		stats_to_allocate += 4
	elif stats.level >= 31:
		stats_to_allocate += 5
	print('Level ', stats.level, ' achieved. Current total stats_to_allocate: ', stats_to_allocate)
	if dying:
		return
	else:
		start_level_timer()

func start_level_timer():
	$LevelTimer.start()
	yield($LevelTimer, "timeout")
	if just_leveled:
		show_level_up_screen()

func show_level_up_screen():
	get_node("/root/World/Music").stream_paused = true
	get_node("/root/World/SFX").stream_paused = true
	get_node("/root/World/SFX2").stream_paused = true
	print('Instancing LevelUp. Final total stats_to_allocate = ', stats_to_allocate)
	just_leveled = false
	var tweenGreyscale = TweenGreyscale.instance()
	get_node("/root/World/GUI").add_child(tweenGreyscale)
	var levelUpScreen = LevelUpScreen.instance()
	levelUpScreen.stats_remaining = stats_to_allocate
	stats_to_allocate = 0
	get_node("/root/World/GUI").add_child(levelUpScreen)

#func old_level_up():
#	stats.level += 1
#	# var dialogLevelBox = DialogLevelBox.instance()
#	# get_node("/root/World/GUI").add_child(dialogLevelBox)
#	var levelNotice = LevelNotice.instance()
#	levelNotice.position = Vector2(233, 116)
#	levelNotice.levelDisplay = stats.level
#
#	var choice = levelStats[randi() % levelStats.size()]
#	match choice:
#		LEVELHEALTH:
##			stats.max_health += 15
##			stats.health += 15
#			stats.vitality +=1
#			levelNotice.statDisplay = "WILLPOWER"
#			levelNotice.statColor = Color(0.666, 0.392549, 0)
#		LEVELDEFENSE:
#			stats.defense += 1
#			levelNotice.statDisplay = "HARDINESS"
#			levelNotice.statColor = Color(0.2, 0.2, 1)
#		LEVELSTAMINA:
#			stats.endurance += 1
#			# stats.max_stamina += 15
#			levelNotice.statDisplay = "LUNG CAPACITY"
#			levelNotice.statColor = Color(0.372549, 1, 0.415686)
#		LEVELSTRENGTH:
#			stats.strength += 1
#			levelNotice.statDisplay = "VIOLENT NATURE"
#			levelNotice.statColor = Color(1, 0.12, 0)
#		LEVELDEXTERITY:
#			stats.dexterity += 1
#			levelNotice.statDisplay = "PATIENCE"
#			levelNotice.statColor = Color(0.324902, 0.622549, 0.705686)
#		LEVELSPEED:
#			stats.iframes += 0.1
#			stats.speed += 1
#			levelNotice.statDisplay = "SWIFTNESS"
#			levelNotice.statColor = Color(1, 1, 0.665686)
#	get_node("/root/World/GUI").add_child(levelNotice)

func roll_stamina_drain():
	stats.stamina -= 15
	base_enemy_accuracy = 32
	if hurtbox.timer.is_stopped(): 
		hurtbox.start_invincibility(stats.iframes)
		
# warning-ignore:unused_argument
func roll_state(delta):
	if roll_moving:
		velocity = dir_vector * stats.roll_speed
	else:
		# warning-ignore:integer_division
		velocity = dir_vector * (stats.roll_speed/4)
	animationState.travel("Roll")
	if Input.is_action_just_released("attack_2"):
		if stats.stamina <= 0:
			noStamina()
			charge.stop_charge()
		else:
			if attack_2_charged:
				attack_2_charged = false
				attack_1_charged = false
				shade_queued = true
			elif attack_1_charged:
				attack_1_charged = false
				flash_queued = true
			else: attack1_queued = true
	
#	elif Input.is_action_just_pressed("attack"):
#		if stats.stamina <= 0:
#			noStamina()
#		else:
#			attack1_queued = true
	move()

func roll_stop():
	roll_moving = false
	
func roll_animation_finished():
	if shade_queued:
		shade_queued = false
		velocity = dir_vector * (stats.roll_speed/2)
		attack_2_charged = false
		charge.stop_charge()
		charge_reset()
		attack_charging = false
		state = SHADE
	elif flash_queued:
		base_enemy_accuracy = 16
		flash_queued = false
		velocity = dir_vector * (stats.roll_speed/2)
		charge.stop_charge()
		charge_reset()
		attack_charging = false
		state = FLASH
	elif attack1_queued:
		velocity = dir_vector * -(stats.roll_speed/2)
		attack_animation_finished()
	else:
		attack_animation_finished()

func backstep_stamina_drain():
	stats.stamina -= 5
	base_enemy_accuracy = 16
	if hurtbox.timer.is_stopped(): 
		hurtbox.start_invincibility(stats.iframes)
	else:
		pass

# warning-ignore:unused_argument
func backstep_state(delta):
	if backstep_moving:
		velocity = -dir_vector * (stats.roll_speed*0.66)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, stats.friction * delta)
	animationState.travel("Backstep")
	if Input.is_action_just_released("attack_2"):
		if stats.stamina <= 0:
			noStamina()
			charge.stop_charge()
		else:
			if attack_2_charged:
				attack_1_charged = false # getting rid of this stores the charge for next backstep - mite b cool
				attack_2_charged = false
				shade_queued = true
			elif attack_1_charged:
				attack_1_charged = false
				flash_queued = true
			else:
				attack1_queued = true
	
	elif Input.is_action_just_pressed("roll_2"):
		if stats.stamina <= 0:
			noStamina()
			charge.stop_charge()
		else:
			backstep_queued = true
	
	move()

func backstep_stop():
	base_enemy_accuracy = 50
	backstep_moving = false

func backstep_animation_finished():
	if shade_queued:
		shade_queued = false
		velocity = dir_vector * (stats.roll_speed*0.75)
		attack_2_charged = false
		charge.stop_charge()
		charge_reset()
		attack_charging = false
		state = SHADE
	elif flash_queued:
		base_enemy_accuracy = 0 # Player becomes very difficult to hit during a queued flash
		flash_queued = false
		velocity = dir_vector * (stats.roll_speed)
		charge.stop_charge()
		charge_reset()
		attack_charging = false
		state = FLASH
	elif Input.is_action_pressed("attack_2"):
		attack_animation_finished()
	elif attack1_queued:
		velocity = dir_vector * (stats.roll_speed*0.75)
		attack_animation_finished()
	else:
		attack_animation_finished()

func _on_Hurtbox_area_entered(area):
	var hit = Global.enemy_hit_calculation(base_enemy_accuracy, area.accuracy, stats.speed)
	if hit:
		if attack2_queued:
			attack2_queued = false
		if charge_count > 0:
			charge.stop_charge()
			if attack_charging: attack_charging = false
			if attack_1_charged: attack_1_charged = false
			if attack_2_charged: attack_2_charged = false
			charge_reset()
		var is_crit = false # enemies currently do not crit
		# damageTaken = Global.damage_calculation(area.damage, stats.defense, area.randomness)
		hurtbox.display_damage_popup(str(damageTaken), is_crit)
		state = HIT
	else:
		$DodgeAudio.play()
		hurtbox.display_damage_popup("Miss!", false)

func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
	
func dying_effect(value):
	if value && !dying:
		set_collision_mask_bit(12, true)
		var heartbeat = Heartbeat.instance()
		var greyscale = Greyscale.instance()
		var redFlash = RedFlash.instance()
		get_node("/root/World/").add_child(heartbeat)
		get_node("/root/World/GUI").add_child(greyscale)
		get_node("/root/World/GUI").add_child(redFlash)
		get_node("/root/World/Music").stream_paused = true
		get_node("/root/World/SFX").stream_paused = true
		dying = true
	elif !value && dying:
		set_collision_mask_bit(12, false)
		AudioServer.set_bus_effect_enabled(0, 0, false)
		get_node("/root/World/GUI/Greyscale").queue_free()
		get_node("/root/World/GUI/White").queue_free()
		get_node("/root/World/Heartbeat").queue_free()
		get_node("/root/World/Music").stream_paused = false
		get_node("/root/World/SFX").stream_paused = false
		dying = false
	
func game_over():
	# dying = true
	AudioServer.set_bus_effect_enabled(0, 0, false)
	get_node("/root/World/Heartbeat").stream_paused = true
	get_node("/root/World/Music").stream_paused = true
	var gameOver = GameOver.instance()
	get_node("/root/World/GUI").add_child(gameOver)
	get_node("/root/World/GUI/HealthUI").visible = false
	get_node("/root/World/GUI/ExpBar").visible = false
	get_node("/root/World/GUI/StaminaBar").visible = false
	self.visible = false
	get_tree().paused = true

# when the Player interacts with something, their interactHitbox is disabled
# the TalkTimer is started lasting for 0.5 seconds (default)
func _on_TalkTimer_timeout():
	# on timeout, the interactHitbox is re-enabled
	# interactHitbox.disabled = false
	# checks if an interactable Object is in range
	if interactObject != null:
		# if the Player is talking (ie. the object is talkable), sets the talk notice
		if talking:
			self.talkNoticeDisplay = true
		# if the Object is not fully examined, sets the notice
		if examining && !interactObject.examined:
			self.noticeDisplay = true
			
func set_notice(value):
	if value:
		$NoticeAudio.play()
		notice.visible = true
	elif !value:
		notice.visible = false
		
func set_talk_notice(value):
	if value:
		$NoticeAudio.play()
		talkNotice.visible = true
	elif !value:
		talkNotice.visible = false

func set_interact_notice(value):
	if value:
		$NoticeAudio.play()
		interactNotice.visible = true
	elif !value:
		interactNotice.visible = false

# function that runs when the player's InteractHitbox detects an area entererd
func _on_InteractHitbox_area_entered(area):
	# gets the object in the interact bounding box
	if dying:
		return
	interactObject = area.get_owner()
	examining = true
	# displays notice is object not examined
	if !interactObject.examined:
		self.noticeDisplay = true
	# displays talk notice if the object is talkable
	if interactObject.talkable:
		self.talkNoticeDisplay = true
		talking = true
	# else displays interact notice if the object is interactable
	if interactObject.interactable:
		self.interactNoticeDisplay = true
		interacting = true
#	if "item_usable" in interactObject:
#		var item_to_use = player1.inventory._items[player1.inventory.current_selected_item]
#		if item_to_use.item_reference.name == interactObject.item_needed:
#			using_item = true
#			print('using_item = true')

func _on_InteractHitbox_area_exited(_area):
	self.noticeDisplay = false
	self.talkNoticeDisplay = false
	self.interactNoticeDisplay = false
	examining = false
	talking = false
	interacting = false
	using_item = false
	interactObject = null

func reset_animation():
	# get_tree().paused = false
	animationTree.set("parameters/Idle/blend_position", dir_vector)
	# animationState.travel("Idle")