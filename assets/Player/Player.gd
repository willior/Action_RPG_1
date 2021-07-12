extends KinematicBody2D

const Notice = preload("res://assets/UI/Notice.tscn")
const GameOver = preload("res://assets/UI/GameOver.tscn")
const DialogBox = preload("res://assets/UI/DialogBox.tscn")
const LevelUpScreen = preload("res://assets/UI/LevelUp/LevelUpScreen.tscn")
const TweenGreyscale = preload("res://assets/Shaders/Greyscale_TweenCanvasModulate.tscn")
const Greyscale = preload("res://assets/Shaders/Greyscale_CanvasModulate.tscn")
const RedFlash = preload("res://assets/Shaders/Red_CanvasModulate.tscn")
const Heartbeat = preload("res://assets/Audio/SFX/Heartbeat.tscn")

#var inventory_resource = load("res://assets/Player/Inventory.gd")
#var inventory = inventory_resource.new()
const pouch_resource = preload("res://assets/Player/Pouch.gd")
var pouch = pouch_resource.new()
const formulabook_resource = preload("res://assets/Player/FormulaBook.gd")
var formulabook = formulabook_resource.new()
var inventory_ref = "inventory"

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

var stats = Player1Stats
var formulaData = P1FormulaData
var state = MOVE
var velocity = Vector2.ZERO
var dir_vector = stats.dir_vector
var damageTaken = 0
var stamina_regen_level = 0
var movement_speed_mod = 1.0

var roll_moving = false
var backstep_moving = false
var backstep_queued = false
var attack2_queued = false
var attack1_queued = false
var flash_queued = false
var shade_queued = false
var shade_moving = false
var stamina_attack_cost = stats.stamina_attack_cost
var knockback_modifier = 1

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

var player_inputs = {
	"left": "left_1",
	"right": "right_1",
	"up": "up_1",
	"down": "down_1",
	"attack": "attack_1",
	"roll": "roll_1",
	"examine": "examine_1",
	"alchemy": "alchemy_1",
	"previous": "previous_1",
	"next": "next_1",
	"start": "start_1",
	"select": "select_1"
}

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var interactHitbox = $HitboxPivot/InteractHitbox/CollisionShape2D
onready var hurtbox = $Hurtbox
onready var collision = $Hurtbox/CollisionShape2D
onready var timer = $Timer
onready var talkTimer = $TalkTimer
onready var levelTimer = $LevelTimer
onready var notice = $ExamineNotice
onready var talkNotice = $TalkNotice
onready var interactNotice = $InteractNotice
onready var charge = $ChargeUI
onready var bamboo = $BambooAudio

signal player_dead

func _ready():
	if Global.get_attribute("location") != null:
		position = Global.get_attribute("location")
	elif get_tree().get_root().get_node("/root/World/Map").get("player_spawn_pos"):
		position = get_tree().get_root().get_node("/root/World/Map").player_spawn_pos
		print('setting player position to map default')
	else:
		print('no map default; setting player position to that of Camera2D')
		position = get_tree().get_root().get_node("/root/World/Camera2D").position
	if Global.get_attribute(inventory_ref) != null:
		pouch.set_ingredients(Global.get_attribute(inventory_ref)[0].get_ingredients())
		formulabook.set_formulas(Global.get_attribute(inventory_ref)[1].get_formulas())
		GameManager.reinitialize_player(name, pouch, formulabook)
	else:
		GameManager.initialize_player(name)
	animationTree.active = true # animation not active until game starts
	swordHitbox.knockback_vector = dir_vector
	collision.disabled = false
	charge_reset()
	stats.connect("player_dying", self, "dying_effect")
	stats.connect("no_health", self, "game_over")
	stats.connect("max_speed_mod_changed", self, "set_movement_speed_mod")
	stats.connect("attack_speed_changed", self, "set_attack_timescale")
	set_attack_timescale(stats.attack_speed)
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
		STUN: stun_state(delta)

func _input(event):
	match state:
		MOVE:
			if event.is_action_pressed(player_inputs.attack) and !event.is_echo():
				if (!talking and !interacting) and stats.stamina > 0:
					state = ATTACK1
				elif interacting and interactObject.interactable and !dying:
					talkTimer.start()
					interactObject.interact(self)
					if examining:
						self.noticeDisplay = false
				elif talking and interactObject.talkable and talkTimer.is_stopped() and !dying:
					talkTimer.start()
					interactObject.talk()
				elif stats.stamina <= 0:
					no_stamina()
				else:
					state = ATTACK1
			
			if event.is_action_pressed(player_inputs.alchemy): # G
				if formulabook._formulas.size() <= 0 or casting:
					bamboo.play()
					return
				casting = true
				var formula_used = formulabook._formulas[formulabook.current_selected_formula]
				var ingredients = pouch.get_ingredients()
				var ingredients_needed = formula_used.formula_reference.cost.keys()
				var quantity_needed = formula_used.formula_reference.cost.values()
				for i in range(ingredients.size()):
					if ingredients[i].ingredient_reference.name == ingredients_needed[0] and ingredients[i].quantity >= quantity_needed[0]:
						ingredient1_OK = true
						continue
					if ingredients[i].ingredient_reference.name == ingredients_needed[1] and ingredients[i].quantity >= quantity_needed[1]:
						ingredient2_OK = true
						continue
				if ingredient1_OK and ingredient2_OK:
					var FORMULA = formula_used.formula_reference.scene
					var formula = FORMULA.instance()
					ingredient1_OK = false
					ingredient2_OK = false
					formula.player = self
					formula.global_position = global_position
					get_node("/root/World").add_child(formula)
					$CastTimer.start()
					yield($CastTimer, "timeout")
					casting = false
				else:
					casting = false
					ingredient1_OK = false
					ingredient2_OK = false
					bamboo.play()
				
#				var item_used = inventory._items[inventory.current_selected_item]
#				match item_used.item_reference.type:
#					0: # CONSUMABLE
#						inventory.use_item(1)
#					1: # TOOL
#						pass
#					2: # QUEST
#						if talkTimer.is_stopped() and !dying:
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
			if event.is_action_pressed(player_inputs.attack) and !event.is_echo():
				if stats.stamina <= 0:
					no_stamina()
				else:
					attack2_queued = true
		ATTACK2:
			if event.is_action_pressed(player_inputs.attack) and !event.is_echo():
				if stats.stamina <= 0:
					no_stamina()
				else:
					attack1_queued = true
		ACTION:
			pass
		STUN:
			if event.is_action_pressed(player_inputs.attack) or event.is_action_pressed(player_inputs.roll) or event.is_action_pressed(player_inputs.examine) or event.is_action_pressed(player_inputs.alchemy):
				get_tree().set_input_as_handled()
				if !get_node("StatusDisplay").has_node("Stun"):
					print('input detected in player stun state, but no stun node found. returning.')
					return
				var new_time = get_node("StatusDisplay/Stun/Timer").get_time_left()-0.25
				if new_time > 0:
					get_node("StatusDisplay/Stun").advance_stun_time(new_time)
				else:
					get_node("StatusDisplay/Stun/Timer").emit_signal("timeout")
					talkTimer.start()

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength(player_inputs.right) - Input.get_action_strength (player_inputs.left)
	input_vector.y = Input.get_action_strength(player_inputs.down) - Input.get_action_strength(player_inputs.up)
	input_vector = input_vector.normalized()
	stamina_regeneration()
	# if player is moving
	if input_vector != Vector2.ZERO:
		dir_vector = input_vector
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
		velocity = velocity.move_toward(input_vector * stats.max_speed, stats.acceleration * delta)
		
		if GameManager.multiplayer_2:
			Global.check_players_distance(self)
#			if position.x - GameManager.player2.position.x > 288 or position.x - GameManager.player2.position.x < -288 or position.y - GameManager.player2.position.y > 160 or position.y - GameManager.player2.position.y < -136:
#				GameManager.player2.position = position
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, stats.friction * delta)
	swordHitbox.knockback_vector = dir_vector * knockback_modifier
	move()
	
	if Input.is_action_just_pressed(player_inputs.examine): # F
		if !dying and !casting:
			if !examining and talkTimer.is_stopped():
				talkTimer.start()
				var dialogBox = DialogBox.instance()
				dialogBox.dialog_script = [{'text': "You find nothing of interest."}]
				get_node("/root/World/GUI").add_child(dialogBox)
			elif examining and talkTimer.is_stopped():
				talkTimer.start()
				interactObject.examine()
				self.noticeDisplay = false
			
	if Input.is_action_just_pressed(player_inputs.next): # R
		formulabook.advance_selected_formula()
		
	if Input.is_action_just_pressed(player_inputs.previous): # E
		formulabook.previous_selected_formula()

	if Input.is_action_pressed(player_inputs.attack):
		if !talkTimer.is_stopped():
			return
		charge_state(delta)
		
	if Input.is_action_just_released(player_inputs.attack): # V
		match stats.charge_level:
			1:
				apply_evasion_action_bonus(50)
				state = FLASH
			2:
				state = SHADE
			3: # TEMPORARY LV. 3
				state = SHADE
				return
		charge.stop_charge()
		charge_reset()
		
	if Input.is_action_just_pressed(player_inputs.roll): # B
		if stats.stamina > 0:
			if input_vector != Vector2.ZERO:
				roll_moving = true
				state = ROLL
			else:
				backstep_moving = true
				state = BACKSTEP
		else:
			no_stamina()

func stamina_regeneration():
	if sweating:
		stats.stamina += (stats.stamina_regen_rate * 0.6) # sweating rate
		if stats.stamina > 0:
			sweating = false
			stats.sweating = sweating
			$Sweat.visible = false
			$ChargeUI.sweatFlag = false
	
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
		
		if Input.is_action_pressed(player_inputs.attack) || Input.is_action_pressed(player_inputs.roll):
			if timer.is_stopped():
				timer.start()
			return
		elif stamina_regen_level < 5 and timer.is_stopped():
			timer.start(0.4)
			yield(timer, "timeout")
			stamina_regen_level += 1

func stamina_regen_reset():
	if stamina_regen_level > 0:
		stamina_regen_level = 0
	timer.start(0.8)

func move():
	if GameManager.multiplayer_2:
		if position.x - GameManager.player2.position.x > 450:
			GameManager.player2.position.x += 1
		if position.x - GameManager.player2.position.x < -450:
			GameManager.player2.position.x -= 1
		if position.y - GameManager.player2.position.y > 250:
			GameManager.player2.position.y += 1
		if position.y - GameManager.player2.position.y < -250:
			GameManager.player2.position.y -= 1
	velocity = move_and_slide(velocity)

func no_stamina():
	$BambooAudio.play()

func set_sweating():
	$Sweat.visible = true
	sweating = true
	stats.sweating = sweating
	$ChargeUI.sweatFlag = true

func set_movement_speed_mod(value):
	animationTree.set("parameters/Run/TimeScale/scale", value)

func set_attack_timescale(value):
	animationTree.set("parameters/Attack1/TimeScale/scale", value)
	animationTree.set("parameters/Attack2/TimeScale/scale", value)

func set_stamina_attack_cost(value):
	stamina_attack_cost = value

# 1st attack pressed: state switches to attack1, plays attack1
# 2nd attack pressed: attack2_queued becomes true
# on attack1_animation_finished, checks attack2_queued
# if true, plays attack2; attack2_queued becomes false
# 3rd attack pressed: attack1_queued becomes true
# on attack2_animation_finished, checks attack1_queued
# if true, plays attack1; attack1_queued becomes false, etc.
func attack1_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, (stats.friction/2) * delta)
	animationState.travel("Attack1")
	move()

func attack2_state(_delta):
	animationState.travel("Attack2")
	move()

func attack1_stamina_drain():
	swordHitbox.enable_sword_hitbox()
	stats.stamina -= stamina_attack_cost
	swordHitbox.sword_attack_audio()

func attack2_stamina_drain():
	swordHitbox.enable_sword_hitbox()
	stats.stamina -= stamina_attack_cost/1.5
	swordHitbox.sword_attack_audio()

func attack_animation_finished():
	swordHitbox.set_deferred("monitorable", false)
	apply_evasion_action_bonus(0)
	if stats.dexterity_bonus != 0:
		stats.dexterity_bonus = 0
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
		if !Input.is_action_pressed(player_inputs.attack):
			charge_reset()

func charge_state(_delta):
	if stamina_regen_level > 0:
		stamina_regen_reset()
	stats.stamina -= 0.4
	if stats.stamina <= 0:
		charge.stop_charge()
		charge_reset()
		if !sweating:
			set_sweating()
			no_stamina()
		return
	
	if stats.charge == 0 and stats.charge_level == 0 and stats.stamina > 1:
		charge.begin_charge_1()
	elif stats.charge >= 50 and stats.charge_level == 0:
		stats.charge_level = 1
		if stats.weapon_level > 1:
			charge.begin_charge_2()
	elif stats.charge >= 100 and stats.charge_level == 1:
		stats.charge_level = 2
		if stats.weapon_level > 2:
			charge.begin_charge_3()
	elif stats.charge >= 150 and stats.charge_level == 2:
		stats.charge_level = 3
		if stats.weapon_level > 3:
			print('we would begin charge 4 here, if it existed')
	
	if stats.charge < stats.max_charge:
		if stats.charge_level >= 2:
			stats.charge += stats.charge_rate / 2
		else:
			stats.charge += stats.charge_rate

func charge_reset():
	if stats.charge_level != 0: stats.charge_level = 0
	if stats.charge != 0: stats.charge = 0

func shade_state(delta):
	if shade_moving:
		velocity = velocity.move_toward(Vector2.ZERO, stats.friction/2 * delta)
	else:
		if Input.is_action_just_released(player_inputs.attack):
			attack2_queued = true
	animationState.travel("Shade")
	move()

func shade_start():
	# TEMPORARY LV. 3
	if stats.charge_level >= 3:
		velocity = dir_vector * stats.shade_speed * stats.charge_level/2
	else:
		velocity = dir_vector * stats.shade_speed
	charge.stop_charge()
	charge_reset()
	set_collision_mask_bit(4, false)
	yield(get_tree().create_timer(0.05), "timeout")
	stats.stamina -= 35
	charge.stop_charge()
	swordHitbox.shade_begin()

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
	swordHitbox.reset_damage()
	shade_moving = false

func flash_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, stats.friction/2 * delta)
	animationState.travel("Flash")
	move()

func flash_start():
	stats.stamina -= 25
	charge.stop_charge()
	swordHitbox.flash_begin()

func flash_stop():
	apply_evasion_action_bonus(0)
	swordHitbox.reset_damage()

func player_state_reset():
	apply_evasion_action_bonus(0)
	swordHitbox.reset_damage()

func roll_stamina_drain():
	stats.stamina -= 15
	apply_evasion_action_bonus(50)
	hurtbox.start_invincibility(min(stats.iframes, 0.35))

func roll_state(_delta):
	if roll_moving:
		velocity = dir_vector * stats.roll_speed
	else:
		velocity = dir_vector * (stats.roll_speed/4)
	animationState.travel("Roll")
	move()
	if Input.is_action_just_released(player_inputs.attack):
		if stats.stamina <= 0:
			no_stamina()
			charge.stop_charge()
		else:
			if stats.charge_level == 2:
				shade_queued = true
			elif stats.charge_level == 1:
				flash_queued = true
			elif stats.charge > 0:
				return
			else:
				attack1_queued = true

func roll_stop():
	roll_moving = false
	
func roll_animation_finished():
	if shade_queued:
		shade_queued = false
		velocity = dir_vector * (stats.roll_speed/2)
		charge.stop_charge()
		charge_reset()
		state = SHADE
		return
	elif flash_queued:
		flash_queued = false
		velocity = dir_vector * (stats.roll_speed/2)
		charge.stop_charge()
		charge_reset()
		apply_evasion_action_bonus(66)
		state = FLASH
		return
	if stats.charge > 0:
		charge.stop_charge()
		charge_reset()
	if attack1_queued:
		velocity = dir_vector * -(stats.roll_speed/2)
		attack_animation_finished()
	else:
		attack_animation_finished()

func backstep_stamina_drain():
	stats.stamina -= 5
	apply_evasion_action_bonus(66)
	hurtbox.start_invincibility(min(stats.iframes, 0.24))

func backstep_state(delta):
	if backstep_moving:
		velocity = -dir_vector * (stats.roll_speed*0.66)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, stats.friction * delta)
	animationState.travel("Backstep")
	move()
	if Input.is_action_just_released(player_inputs.attack):
		if stats.stamina <= 0:
			no_stamina()
			charge.stop_charge()
		else:
			if stats.charge_level == 2:
				shade_queued = true
			elif stats.charge_level == 1:
				flash_queued = true
			elif stats.charge > 0:
				return
			else:
				attack1_queued = true
	elif Input.is_action_just_pressed(player_inputs.roll):
		if stats.stamina <= 0:
			no_stamina()
			charge.stop_charge()
		else:
			backstep_queued = true

func backstep_stop():
	apply_evasion_action_bonus(50)
	backstep_moving = false

func backstep_animation_finished():
	if shade_queued:
		shade_queued = false
		velocity = dir_vector * (stats.roll_speed*0.75)
		charge.stop_charge()
		charge_reset()
		state = SHADE
	elif flash_queued:
		flash_queued = false
		velocity = dir_vector * (stats.roll_speed)
		charge.stop_charge()
		charge_reset()
		apply_evasion_action_bonus(75) # Player becomes very difficult to hit during a queued flash
		state = FLASH
	elif Input.is_action_pressed(player_inputs.attack):
		attack_animation_finished()
	elif attack1_queued:
		velocity = dir_vector * (stats.roll_speed*0.75)
		attack_animation_finished()
	else:
		attack_animation_finished()

func apply_evasion_action_bonus(value):
	if value != stats.evasion_action_bonus:
		stats.evasion_action_bonus = value

func _on_Formulabox_area_entered(area):
	var element_mod
	if area.get("element")!=null and stats.get("affinity")!=null:
		element_mod = Element.calculate_element_ratio(area.element, stats.affinity)
	else:
		element_mod = 1
	if area.get("damage_formula"):
		damageTaken = Global.formula_calculation(area.potency, 0, area.randomness, element_mod)
		stats.health -= damageTaken
		if damageTaken < 0:
			hurtbox.display_damage_popup(str(abs(damageTaken)), false, "Heal")
		else:
			hurtbox.display_damage_popup(str(damageTaken), false)
	if area.get("status"):
		StatusHandler.apply_status(area.status, self)

func _on_Hurtbox_area_entered(area):
	if z_index != area.get_parent().z_index: # automatic miss if z_index mismatch
		$DodgeAudio.play()
		hurtbox.display_damage_popup("Miss!", false)
		print(area.get_parent().name, ' missed Player due to altitude difference')
		return
	var hit = Global.hit_calculation(area.accuracy, stats.evasion)
	if hit:
		var element_mod
		if area.get("element")!=null and stats.get("affinity")!=null:
			element_mod = Element.calculate_element_ratio(area.element, stats.affinity)
		else:
			element_mod = 1
		damageTaken = Global.damage_calculation(area.damage, stats.defense, area.randomness, element_mod)
		var is_crit = Global.crit_calculation(area.crit_chance)
		if is_crit:
			damageTaken *= 2
			print(self.name, " got critted")
			Global.display_message_popup(self.name, str(self.name, " gets whacked!"), "crit")
		var player_staggered = Global.player_stagger_calculation(stats.max_health, damageTaken, is_crit)
		if attack2_queued and player_staggered:
			attack2_queued = false
		if stats.charge > 0 and player_staggered:
			charge.stop_charge()
			charge_reset()
		hurtbox.display_damage_popup(str(damageTaken), is_crit)
		if area.get("status"):
			StatusHandler.apply_status(area.status, self)
		hit_damage()
		if state != ACTION:
			if state == STUN:
				player_state_reset()
				velocity = -dir_vector * 50
				animationState.travel("Stun")
				return
			elif player_staggered:
				player_state_reset()
				state = HIT
	else:
		$DodgeAudio.play()
		hurtbox.display_damage_popup("Miss!", false)

func hit_damage():
	if self.has_node("StatusDisplay/Stun") and get_node("StatusDisplay/Stun").get_stun_time_remaining() < get_node("StatusDisplay/Stun").duration:
		get_node("StatusDisplay/Stun").interrupt_stun()
	stats.health -= damageTaken
	damageTaken = 0
	$HurtAudio.play()
	hurtbox.start_invincibility(1)
	hurtbox.create_hit_effect()

func stun_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, stats.friction/4 * delta)
	move()
	if examining:
		self.noticeDisplay = false
	if talking:
		self.talkNoticeDisplay = false
	if interacting:
		self.interactNoticeDisplay = false

func hit_state(_delta):
	velocity = -dir_vector * 100
	animationState.travel("Hit")
	move()

func hit_animation_finished():
	if state == MOVE:
		return
	stamina_regen_reset()
	player_state_reset()
	charge.stop_charge()
	charge_reset()
	state = MOVE

func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")

func enemy_killed(experience_from_kill):
	stats.experience += experience_from_kill
	stats.experience_total += experience_from_kill
	while stats.experience >= stats.experience_required:
		level_up()
		stats.experience -= stats.experience_required
		stats.experience_required = round(stats.experience_required * 1.618034)

func level_up():
	stats.leveling = true
	stats.level += 1
	if stats.level < 11:
		stats.attributes_to_allocate += 2
	elif stats.level < 21:
		stats.attributes_to_allocate += 3
	elif stats.level < 31:
		stats.attributes_to_allocate += 4
	elif stats.level >= 31:
		stats.attributes_to_allocate += 5
	for p in get_tree().get_nodes_in_group("Players"):
		if p.dying:
			return
	# start_level_timer()

func start_level_timer():
	# Global.enable_exits(false)
	levelTimer.start()
	yield(levelTimer, "timeout")
	if stats.attributes_to_allocate < 1:
		print('no attributes_to_allocate. cannot level.')
		bamboo.play()
		return
	show_level_up_screen()

func show_level_up_screen():
	get_node("/root/World/Music").stream_paused = true
	get_node("/root/World/SFX").stream_paused = true
	get_node("/root/World/SFX2").stream_paused = true
	var tweenGreyscale = TweenGreyscale.instance()
	get_node("/root/World/GUI").add_child(tweenGreyscale)
	var levelUpScreen = LevelUpScreen.instance()
	levelUpScreen.player_name = name
	levelUpScreen.stats = stats
	# levelUpScreen.stats_remaining = stats.attributes_to_allocate
	# stats.attributes_to_allocate = 0
	get_node("/root/World/GUI").add_child(levelUpScreen)
	stats.leveling = false
	for p in get_tree().get_nodes_in_group("Players"):
		if p.stats.leveling:
			return
	Global.enable_exits(true)

func dying_effect(value):
	if value and !dying:
		dying = true
		Global.enable_exits(false)
		for p in get_tree().get_nodes_in_group("Players"):
			if p.stats.leveling:
				p.levelTimer.stop()
		StatusHandler.remove_buffs(self)
		Engine.time_scale = 0.6
		if !has_node("/root/World/Heartbeat"):
			var heartbeat = Heartbeat.instance()
			get_node("/root/World/").add_child(heartbeat)
		if !has_node("/root/World/GUI/Greyscale"):
			var greyscale = Greyscale.instance()
			get_node("/root/World/GUI").add_child(greyscale)
		if !has_node("/root/World/GUI/Red"):
			var redFlash = RedFlash.instance()
			get_node("/root/World/GUI").add_child(redFlash)
		get_node("/root/World/Music").stream_paused = true
		get_node("/root/World/SFX").stream_paused = true
		get_node("/root/World/SFX2").stream_paused = true
	elif !value and dying:
		dying = false
		for p in get_tree().get_nodes_in_group("Players"):
			if p.dying:
				return
		Engine.time_scale = 1
		AudioServer.set_bus_effect_enabled(0, 0, false)
		get_node("/root/World/Heartbeat").queue_free()
		get_node("/root/World/GUI/Greyscale").queue_free()
		get_node("/root/World/GUI/Red").queue_free()
		get_node("/root/World/Music").stream_paused = false
		get_node("/root/World/SFX").stream_paused = false
		get_node("/root/World/SFX2").stream_paused = false
		for p in get_tree().get_nodes_in_group("Players"):
			if p.stats.leveling: # just_leveled:
				p.start_level_timer()
			else:
				Global.enable_exits(true)

func game_over():
	Engine.time_scale = 1
	AudioServer.set_bus_effect_enabled(0, 0, false)
	get_node("/root/World/Heartbeat").stream_paused = true
	get_node("/root/World/Music").stream_paused = true
	var gameOver = GameOver.instance()
	get_node("/root/World/GUI").add_child(gameOver)
	get_tree().paused = true
	emit_signal("player_dead", name)
	get_node("/root/World/GUI").hide_UI_elements()
	self.visible = false

func pickup_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, stats.friction * delta)
	move()
	if examining:
		self.noticeDisplay = false
	if talking:
		self.talkNoticeDisplay = false
	if interacting:
		self.interactNoticeDisplay = false
	animationState.travel("Pickup")

func pickup_finished():
	if state == MOVE:
		return
	if Input.is_action_pressed(player_inputs.attack):
		charge_reset()
	state = MOVE

func action_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, stats.friction * delta)
	move()
	if examining:
		self.noticeDisplay = false
	if talking:
		self.talkNoticeDisplay = false
	if interacting:
		self.interactNoticeDisplay = false

func action_finished():
	animationTree.active = true
	reset_interaction()
	if has_node("StatusDisplay/Stun"):
		state = STUN
		animationState.travel("Stun")
		return
	if !Input.is_action_pressed(player_inputs.attack):
		charge.stop_charge()
		charge_reset()
	state = MOVE

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
		if examining and !interactObject.examined:
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

func _on_InteractHitbox_area_entered(area):
	if dying:
		return
	interactObject = area.get_parent()
	examining = true
	if !interactObject.examined:
		self.noticeDisplay = true
	if interactObject.talkable:
		self.talkNoticeDisplay = true
		talking = true
	if interactObject.interactable:
		self.interactNoticeDisplay = true
		interacting = true
	if "outline" in interactObject:
		# interactObject.show_outline()
		Global.show_outline(interactObject)
#	if "item_usable" in interactObject:
#		var item_to_use = inventory._items[inventory.current_selected_item]
#		if item_to_use.item_reference.name == interactObject.item_needed:
#			using_item = true
#			print('using_item = true')

func _on_InteractHitbox_area_exited(area):
	if "outline" in area.get_parent():
		# area.get_parent().hide_outline()
		Global.hide_outline(area.get_parent())
	if interactObject == area.get_parent():
		interactObject = null
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
		reset_interaction()

func reset_interaction():
	interactHitbox.set_deferred("disabled", true)
	interactHitbox.set_deferred("disabled", false)

func reset_animation():
	get_tree().paused = false
	animationTree.set("parameters/Idle/blend_position", dir_vector)

func check_attack_input():
	if !Input.is_action_pressed(player_inputs.attack):
		charge.stop_charge()
		charge_reset()
	# get_node("/root/World/Music").stream_paused = false

func set_z_index(value):
	z_index = value
