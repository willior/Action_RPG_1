extends KinematicBody2D

const Notice = preload("res://assets/UI/Notice.tscn")
const Poison = preload("res://assets/UI/Status/PoisonNotice.tscn")
const LevelNotice = preload("res://assets/UI/LevelNotice.tscn")
const GameOver = preload("res://assets/UI/GameOver.tscn")
const DialogBox = preload("res://assets/UI/DialogBox.tscn")
const DialogLevelBox = preload("res://assets/UI/DialogLevelBox.tscn")
const TweenGreyscale = preload("res://assets/Shaders/Greyscale_TweenCanvasModulate.tscn")
const Greyscale = preload("res://assets/Shaders/Greyscale_CanvasModulate.tscn")
const RedFlash = preload("res://assets/Shaders/Red_CanvasModulate.tscn")
const Heartbeat = preload("res://assets/Audio/SFX/Heartbeat.tscn")

var inventory_resource = load("res://assets/Player/Inventory.gd")
var inventory = inventory_resource.new()
var pouch_resource = load("res://assets/Player/Pouch.gd")
var pouch = pouch_resource.new()

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
	ACTION
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
	if Global.get_attribute("inventory") != null:
		# var new_inventory = Global.get_attribute("inventory").get_items()
		inventory.set_items(Global.get_attribute("inventory")[0].get_items())
		pouch.set_ingredients(Global.get_attribute("inventory")[1].get_ingredients())
		GameManager.reinitialize_player(inventory, pouch)
	else:
		GameManager.initialize_player()
	animationTree.active = true # animation not active until game starts
	swordHitbox.knockback_vector = dir_vector
	collision.disabled = false
	charge_reset()
	stats.connect("status_changed", self, "apply_status")
	stats.connect("player_dying", self, "dying_effect")
	stats.connect("no_health", self, "game_over")
	stats.connect("attack_speed_changed", self, "set_attack_timescale")
	set_attack_timescale(PlayerStats.attack_speed)
	PlayerStats.status = "default_speed"
	Global.set_world_collision(self, z_index)

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
		PICKUP: pickup_state(delta)
		ACTION: action_state(delta)

func _input(event):
	match state:
		MOVE:
			if event.is_action_pressed("attack") && !event.is_echo():
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
					
			if event.is_action_pressed("item"): # G
				var item_used = inventory._items[inventory.current_selected_item]
				match item_used.item_reference.type:
					0: # CONSUMABLE
						inventory.use_item(1)
					1: # TOOL
						pass
					2: # QUEST
						if talkTimer.is_stopped() && !dying:
							if !using_item:
								talkTimer.start()
								var dialogBox = DialogBox.instance()
								dialogBox.dialog_script = [{'text': "Can't use that here."}]
								get_node("/root/World/GUI").add_child(dialogBox)
								return
							else:
								talkTimer.start()
								interactObject.use_item_on_object()
		
		ATTACK1:
			if event.is_action_pressed("attack") && !event.is_echo():
				if stats.stamina <= 0:
					noStamina()
				else:
					attack2_queued = true
		ATTACK2:
			if event.is_action_pressed("attack") && !event.is_echo():
				if stats.stamina <= 0:
					noStamina()
				else:
					attack1_queued = true
		ACTION:
			print('input in ACTION state')

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength ("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	stamina_regeneration()

	# if player is moving
	if input_vector != Vector2.ZERO:
		dir_vector = input_vector
		if PlayerStats.frenzy.active:
			swordHitbox.knockback_vector = input_vector / 10
		else:
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
		if GameManager.multiplayer_2:
			if position.x - Global.player2.position.x > 288 or position.x - Global.player2.position.x < -288 or position.y - Global.player2.position.y > 160 or position.y - Global.player2.position.y < -136:
				Global.player2.position = position
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, stats.friction * delta)
		
	move()
	
	if Input.is_action_just_pressed("examine"): # F
		if !dying:
			if !examining && talkTimer.is_stopped():
				talkTimer.start()
				var dialogBox = DialogBox.instance()
				dialogBox.dialog_script = [{'text': "You find nothing of interest."}]
				get_node("/root/World/GUI").add_child(dialogBox)
			elif examining && talkTimer.is_stopped():
				talkTimer.start()
				interactObject.examine()
			
	if Input.is_action_just_pressed("next_item"): # R
		inventory.advance_selected_item()
		interactHitbox.disabled = true
		interactHitbox.disabled = false
		
	if Input.is_action_just_pressed("previous_item"): # E
		inventory.previous_selected_item()
		interactHitbox.disabled = true
		interactHitbox.disabled = false

	if Input.is_action_pressed("attack"):
		if !talkTimer.is_stopped():
			return
		elif charge_count == 0 && charge_level_count == 0 && stats.stamina > 1:
			charge.begin_charge_1()
		elif charge_count == stats.max_charge/2 && charge_level_count == 1:
			charge.begin_charge_2()
		charge_state(delta)
			
	if Input.is_action_just_released("attack"): # V
		if attack_2_charged or stats.charge_level == 2:
			attack_2_charged = false
			state = SHADE
		elif attack_1_charged and stats.charge_level == 1:
			attack_1_charged = false
			state = FLASH
		charge.stop_charge()
		charge_reset()
		
	if Input.is_action_just_pressed("roll"): # B
		if stats.stamina > 0:
			if input_vector != Vector2.ZERO:
				roll_moving = true
				state = ROLL
			else:
				backstep_moving = true
				state = BACKSTEP
		else:
			noStamina()

func stamina_regeneration():
	if sweating:
		stats.stamina += (stats.stamina_regen_rate * 0.6) # sweating rate
		if stats.stamina > 0:
			sweating = false
			$Sweat.visible = false
			$ChargeUI.sweatFlag = false
			stats.status = "sweating_end"
	
	elif stats.stamina < stats.max_stamina:
		match stamina_regen_level:
			0:
				stats.stamina += stats.stamina_regen_rate
			1:
				stats.stamina += stats.stamina_regen_rate * 2
			2:
				stats.stamina += stats.stamina_regen_rate * 4
			3:
				stats.stamina += stats.stamina_regen_rate * 8
			4:
				stats.stamina += stats.stamina_regen_rate * 16
			5:
				stats.stamina += stats.stamina_regen_rate * 32
		
		if Input.is_action_pressed("attack") || Input.is_action_pressed("roll"):
			if timer.is_stopped():
				timer.start()
			return
		elif stamina_regen_level < 5 && timer.is_stopped():
			timer.start(0.5)
			yield(timer, "timeout")
			stamina_regen_level += 1

func stamina_regen_reset():
	if stamina_regen_level > 0:
		stamina_regen_level = 0
	timer.start(1.5)

func apply_status(status):
	match status:
		"default_speed":
			animationTree.set("parameters/Run/TimeScale/scale", 1)
		"sweating":
			set_sweating()
		"slow":
			animationTree.set("parameters/Run/TimeScale/scale", 0.5)
		"poison":
			if !get_node_or_null("/root/World/YSort/Player/PoisonNotice"):
				var poison = Poison.instance()
				add_child(poison)
			else:
				return
		"poison_end":
			print('deleting poison notice')
			get_node("/root/World/YSort/Player/PoisonNotice").queue_free()
		"frenzy":
			$FrenzyAnimationPlayer.play("Start")
			swordHitbox.knockback_vector = dir_vector / 10
			# animationTree.set("parameters/Attack1/TimeScale/scale", PlayerStats.attack_speed)
			# animationTree.set("parameters/Attack2/TimeScale/scale", PlayerStats.attack_speed)
		"frenzy_end":
			$FrenzyAnimationPlayer.play("Stop")
			swordHitbox.knockback_vector = dir_vector
			# animationTree.set("parameters/Attack1/TimeScale/scale", PlayerStats.attack_speed)
			# animationTree.set("parameters/Attack2/TimeScale/scale", PlayerStats.attack_speed)

func move():
	if GameManager.multiplayer_2:
		if position.x - Global.player2.position.x > 272:
			Global.player2.position.x += 1
			#return
		if position.x - Global.player2.position.x < -272:
			Global.player2.position.x -= 1
			#return
		if position.y - Global.player2.position.y > 136:
			Global.player2.position.y += 1
			#return
		if position.y - Global.player2.position.y < -136:
			Global.player2.position.y -= 1
			#return
	velocity = move_and_slide(velocity)

func noStamina():
	$BambooAudio.play()

func set_sweating():
	$Sweat.visible = true
	sweating = true
	$ChargeUI.sweatFlag = true
	print('set sweating')

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
	if PlayerStats.frenzy.active:
		stats.stamina -= 3
	else:
		stats.stamina -= 15
	swordHitbox.sword_attack_audio()
	swordHitbox.set_deferred("monitorable", true)

func attack2_stamina_drain():
	if PlayerStats.frenzy.active:
		stats.stamina -= 2
	else:
		stats.stamina -= 10
	swordHitbox.sword_attack_audio()
	swordHitbox.set_deferred("monitorable", true)

func attack_animation_finished():
	swordHitbox.set_deferred("monitorable", false)
	base_enemy_accuracy = 66
	PlayerStats.dexterity_mod = 0
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
		stamina_regen_reset()
		state = MOVE
	# if attack button is held when an attack animation finishes
	if Input.is_action_pressed("attack"):
		attack_charging = true
		# charge_reset()

# when an attack animation finishes, checks to see if the button is still held
# if it is, changes the player state to "charging"
# if the player releases the attack button, charging state ends
# if the player holds the button for enough time, charge_level_1 is achieved
# if the player continues to hold the button, charge_level_2 is achieved
# releasing the attack button after achieving a charge level unleashes a special attack
func charge_state(_delta):
	if stamina_regen_level > 0:
		stamina_regen_reset()
	# stamina drain
	stats.stamina -= 0.55
	
	if stats.stamina <= 0:
		charge.stop_charge()
		charge_reset()
		if !sweating:
			stats.status = "sweating"
			noStamina()
		return
		
	# if the current charge is less than the max charge
	if charge_count < stats.max_charge:
		charge_count += stats.charge_rate
		stats.charge = charge_count
	# if the charge count reaches 50%
	if charge_count >= stats.max_charge/2 && !attack_1_charged && !attack_2_charged:
		attack_1_charged = true
	# if the charge count reaches 100%
	elif charge_count >= stats.max_charge && attack_charging:
		attack_1_charged = false
		attack_2_charged = true
		attack_charging = false

func charge_reset():
	charge_level_count = 0
	stats.charge_level = charge_level_count
	charge_count = 0
	stats.charge = charge_count
	if attack_charging: attack_charging = false
	if attack_1_charged: attack_1_charged = false
	if attack_2_charged: attack_2_charged = false

func shade_state(delta):
	if shade_moving:
# warning-ignore:integer_division
		velocity = velocity.move_toward(Vector2.ZERO, stats.friction/2 * delta)
	else:
		if Input.is_action_just_released("attack"):
			attack2_queued = true
	animationState.travel("Shade")
	move()
	
func shade_start():
	set_collision_mask_bit(4, false)
	yield(get_tree().create_timer(0.05), "timeout")
	stats.stamina -= 35
	PlayerStats.dexterity_mod = 8
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
	stats.stamina -= 25
	PlayerStats.dexterity_mod = 4
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
	stamina_regen_reset()
	player_state_reset()
	if Input.is_action_pressed("attack"):
		charge_reset()
		attack_charging = true
	state = MOVE
	
func player_state_reset():
	base_enemy_accuracy = 66
	charge.stop_charge()
	swordHitbox.set_deferred("monitorable", false)
	swordHitbox.damage = swordHitbox.orig_damage
	swordHitbox.reset_damage()
	
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
	print('LevelTimer timeout. Final total stats_to_allocate = ', stats_to_allocate)
	just_leveled = false
	var dialogLevelBox = DialogLevelBox.instance()
	dialogLevelBox.stats_remaining = stats_to_allocate
	stats_to_allocate = 0
	get_node("/root/World/Overlay").add_child(dialogLevelBox)
	var tweenGreyscale = TweenGreyscale.instance()
	get_node("/root/World/GUI").add_child(tweenGreyscale)

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
	if Input.is_action_just_released("attack"):
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
	if Input.is_action_just_released("attack"):
		if stats.stamina <= 0:
			noStamina()
			charge.stop_charge()
		else:
			if attack_2_charged:
				print('attack 2 charged: released during backstep')
				attack_1_charged = false # getting rid of this stores the charge for next backstep - mite b cool
				attack_2_charged = false
				shade_queued = true
			elif attack_1_charged:
				print('attack 1 charged: released during backstep')
				attack_1_charged = false
				flash_queued = true
			else:
				attack1_queued = true
	
	elif Input.is_action_just_pressed("roll"):
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
	elif Input.is_action_pressed("attack"):
		attack_animation_finished()
	elif attack1_queued:
		velocity = dir_vector * (stats.roll_speed*0.75)
		attack_animation_finished()
	else:
		attack_animation_finished()

func _on_Hurtbox_area_entered(area):
	if z_index != area.get_parent().z_index: # automatic miss if z_index mismatch
		$DodgeAudio.play()
		hurtbox.display_damage_popup("Miss!", false)
		print(area.get_parent().name, ' missed Player due to altitude difference')
		return
	var hit = Global.enemy_hit_calculation(base_enemy_accuracy, area.accuracy, stats.speed)
	if hit:
		if attack2_queued:
			attack2_queued = false
		if charge_count > 0:
			charge.stop_charge()
			charge_reset()
		var is_crit = false # enemies currently do not crit
		damageTaken = Global.damage_calculation(area.damage, stats.defense, area.randomness)
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
		Engine.time_scale = 0.6
		set_collision_mask_bit(10, false)
		var heartbeat = Heartbeat.instance()
		var greyscale = Greyscale.instance()
		var redFlash = RedFlash.instance()
		get_node("/root/World/").add_child(heartbeat)
		get_node("/root/World/GUI").add_child(greyscale)
		get_node("/root/World/GUI").add_child(redFlash)
		get_node("/root/World/Music").stream_paused = true
		get_node("/root/World/SFX").stream_paused = true
		get_node("/root/World/SFX2").stream_paused = true
		dying = true
	elif !value && dying:
		Engine.time_scale = 1
		set_collision_mask_bit(10, true)
		AudioServer.set_bus_effect_enabled(0, 0, false)
		get_node("/root/World/GUI/Greyscale").queue_free()
		get_node("/root/World/GUI/Red").queue_free()
		get_node("/root/World/Heartbeat").queue_free()
		get_node("/root/World/Music").stream_paused = false
		get_node("/root/World/SFX").stream_paused = false
		get_node("/root/World/SFX2").stream_paused = false
		dying = false
		emit_signal("player_saved")
		if just_leveled:
			start_level_timer()

func game_over():
	# dying = true
	AudioServer.set_bus_effect_enabled(0, 0, false)
	get_node("/root/World/Heartbeat").stream_paused = true
	get_node("/root/World/Music").stream_paused = true
	var gameOver = GameOver.instance()
	get_node("/root/World/GUI").add_child(gameOver)
	get_node("/root/World/GUI/HealthUI1").visible = false
	get_node("/root/World/GUI/ExpBar1").visible = false
	get_node("/root/World/GUI/StaminaBar1").visible = false
	self.visible = false
	get_tree().paused = true
	
func pickup_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, stats.friction * delta)
	move()
	if examining:
		self.noticeDisplay = false
	if talking:
		# talking = false
		self.talkNoticeDisplay = false
	if interacting:
		# interacting = false
		self.interactNoticeDisplay = false
	animationState.travel("Pickup")

func pickup_finished():
	reset_interaction()
	if Input.is_action_pressed("attack"):
		charge_reset()
		attack_charging = true
	state = MOVE
	
func action_state(_delta):
	if examining:
		self.noticeDisplay = false
	if talking:
		# talking = false
		self.talkNoticeDisplay = false
	if interacting:
		# interacting = false
		self.interactNoticeDisplay = false

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
	#interactObject = area.get_owner()
	interactObject = area.get_parent()
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
	if "item_usable" in interactObject:
		var item_to_use = inventory._items[inventory.current_selected_item]
		if item_to_use.item_reference.name == interactObject.item_needed:
			using_item = true
			print('using_item = true')

func _on_InteractHitbox_area_exited(_area):
	self.noticeDisplay = false
	self.talkNoticeDisplay = false
	self.interactNoticeDisplay = false
	if examining:
		examining = false
	if talking:
		talking = false
	if interacting:
		interacting = false
	if using_item:
		using_item = false
	if interactObject:
		interactObject = null
	reset_interaction()
	
func reset_interaction():
	interactHitbox.set_deferred("disabled", true)
	interactHitbox.set_deferred("disabled", false)

func reset_animation():
	get_tree().paused = false
	animationTree.set("parameters/Idle/blend_position", dir_vector)
	# animationState.travel("Idle")

func check_attack_input():
	if !Input.is_action_pressed("attack"):
		charge.stop_charge()
		charge_reset()
	get_node("/root/World/Music").stream_paused = false

func save():
	# instead of saving a REFERENCE to the inventory's _items array, the array data itself should be gotten
	# this requires parsing through the array
	var save_dict = {
		"inventory": inventory._items,
		"pouch": pouch._ingredients
	}
	return save_dict

func set_z_index(value):
	z_index = value
