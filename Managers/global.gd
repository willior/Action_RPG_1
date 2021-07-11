extends Node

const BloodHitEffect = preload("res://assets/Effects/Blood_HitEffect.tscn")
var IngredientPickup = load("res://assets/Ingredients/IngredientPickup.tscn")
const MessagePopup = preload("res://assets/UI/Popups/MessagePopup.tscn")
const Heartbeat = preload("res://assets/Audio/SFX/Heartbeat.tscn")
const Greyscale = preload("res://assets/Shaders/Greyscale_CanvasModulate.tscn")
const RedFlash = preload("res://assets/Shaders/Red_CanvasModulate.tscn")

var player1
var player2

var changingScene = false
var _attributes = null
var current_scene = null

var chapter_display
var chapter_name

var custom_variables = {}
var dialogOpen = false

var in_cutscene = false
var target_screen_open = false

var rng = RandomNumberGenerator.new()

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )
	rng.randomize()

func goto_scene(path, attributes=null):
	_attributes = attributes
	# This function will usually be called from a signal callback,
	# or some other function from the running scene.
	# Deleting the current scene at this point might be
	# a bad idea, because it may be inside of a callback or function of it.
	# The worst case will be a crash or unexpected behavior.
	# The way around this is deferring the load to a later time, when
	# it is ensured that no code from the current scene is running:
	call_deferred("_deferred_goto_scene",path)

func get_attribute(name):
	if _attributes != null and _attributes.has(name):
		return _attributes[name]
	return null

func _deferred_goto_scene(path):
	# Immediately free the current scene
	current_scene.free()
	# Load new scene
	var s = ResourceLoader.load(path)
	# Instance the new scene
	current_scene = s.instance()
	# Add it to the active scene, as child of root
	get_tree().get_root().add_child(current_scene)
	# optional, to make it compatible with the SceneTree.change_scene() API
	get_tree().set_current_scene( current_scene )

func check_players_distance(player):
	for p in get_tree().get_nodes_in_group("Players"):
		if player == p:
			continue
		elif player != p:
			if player.position.x - p.position.x > 440:
				print('other player too far left')
				p.position = player.position
				# p.position.x += 1
			if player.position.x - p.position.x < -440:
				print('other player too far right')
				p.position = player.position
				# p.position.x -= 1
			if player.position.y - p.position.y > 250:
				print('other player too far up')
				p.position = player.position
				# p.position.y += 1
			if player.position.y - p.position.y < -250:
				print('other player too far down')
				p.position = player.position
				# p.position.y -= 1
			
			
#			if p.position.distance_to(player.position) > 270:
#				print('changing position')
#				p.position = player.position

#func player_hit_calculation(base_accuracy, dexterity, dexterity_bonus, evasion):
#	rng.randomize()
#	var random_value = rng.randf_range(0, 100)
#	var base_hit_rate = base_accuracy + (2*(dexterity+dexterity_bonus))
#	var final_hit_rate = base_hit_rate - evasion
#	# print("player final_hit_rate: ", final_hit_rate, "% > ", "RNG: ", random_value)
#	if final_hit_rate >= random_value:
#		return true
#	elif final_hit_rate < random_value:
#		return false

func hit_calculation(accuracy, evasion):
	rng.randomize()
	var random_value = rng.randf_range(0, 100)
	if accuracy-evasion >= random_value: return true
	else: return false

#func enemy_hit_calculation(base_accuracy, accuracy, evasion):
#	rng.randomize()
#	var random_value = rng.randf_range(0, 100)
#	var base_hit_rate = base_accuracy + (4*accuracy)
#	var final_hit_rate = base_hit_rate - (evasion)
#	if final_hit_rate >= random_value: return true
#	else: return false

func crit_calculation(crit_rate):
	rng.randomize()
	var random_value = rng.randf_range(0, 100)
	if crit_rate >= random_value:
		SoundPlayer.play_sound("crit")
		return true
	else: return false

func player_stagger_calculation(player_max_hp, enemy_damage, is_crit):
	if (enemy_damage / (player_max_hp/10.0) > 1) or is_crit: return true
	else: return false

func damage_calculation(attack, defense, random, element_mod):
	var base_damage = (2*element_mod) * (attack*attack / (max(attack+defense, 1)))
	return random_variance(base_damage, random)

func formula_calculation(amount, defense, random, element_mod):
	var base_damage = max(amount-defense, 1) * element_mod
	return random_variance(base_damage, random)

func random_variance(base_damage, random):
	rng.randomize()
	var random_value = rng.randf_range(1-random, 1+random)
	return int(base_damage * random_value)

func distribute_exp(value):
	var experience_gained = value
	if GameManager.multiplayer_2:
		experience_gained /= 2
		GameManager.player.enemy_killed(experience_gained)
		GameManager.player2.enemy_killed(experience_gained)
	else: GameManager.player.enemy_killed(experience_gained)

func create_blood_effect(damage_count, location, z_index):
	randomize()
	var blood_effect = BloodHitEffect.instance()
	var randX = int(rand_range(-damage_count, damage_count))
	var randY = int(rand_range(-damage_count/2, damage_count))
	blood_effect.global_position = location
	blood_effect.z_index = z_index
	blood_effect.target_position = location + Vector2(randX, randY)
	get_node("/root/World/Map").call_deferred("add_child", blood_effect)

func ingredient_drop(common_drop , common_chance, rare_drop, rare_chance, pos, z):
	# checks an argument (common_chance) against a randf
	# if it passes, drop is guaranteed; then checks a second argument (rare_chance) against a second randf
	# if it passes, the drop is rare; if it doesn't, the drop is common
	randomize()
	var ingredientPickup = IngredientPickup.instance()
	var check_common = randf()
	if GameManager.multiplayer_2:
		common_chance *= (Player1Stats.drop_rate_mod+Player2Stats.drop_rate_mod)
		rare_chance *= (Player1Stats.drop_rate_mod+Player2Stats.drop_rate_mod)
	else:
		common_chance *= Player1Stats.drop_rate_mod
		rare_chance *= Player1Stats.drop_rate_mod
	if check_common <= common_chance:
		var check_rare = randf()
		if check_rare <= rare_chance: ingredientPickup.ingredient_name = rare_drop
		else: ingredientPickup.ingredient_name = common_drop
		get_node("/root/World/YSort/Items").call_deferred("add_child", ingredientPickup)
		ingredientPickup.global_position = pos
		ingredientPickup.z_index = z

func show_outline(object):
	object.outline.show()

func hide_outline(object):
	object.outline.hide()

func display_message_popup(who, message, flash=null):
	var messagePopup = MessagePopup.instance()
	messagePopup.message = message
	messagePopup.flash = flash
	match who:
		"Player":
			messagePopup.get_node("Label").align = 0
			messagePopup.get_node("Label").grow_horizontal = 1
			get_node("/root/World/GUI/MessageDisplay1/MessageContainer").add_child(messagePopup)
		"Player2":
			messagePopup.get_node("Label").align = 2
			messagePopup.get_node("Label").grow_horizontal = 0
			get_node("/root/World/GUI/MessageDisplay2/MessageContainer").add_child(messagePopup)

func reset_input_after_dialog():
	GameManager.player.check_attack_input()
	if GameManager.multiplayer_2:
		GameManager.player2.check_attack_input()

func change_floor(body, destination_z_index):
	body.set_z_index(destination_z_index) # sets the intended z_index for the body enterred
	set_world_collision(body, body.z_index)

func set_world_collision(body, z_index):
	var target_collision
	match z_index: # matches the appropriate collision bit with input body's z_index
		-2:
			target_collision = 11
		0:
			target_collision = 12
		2:
			target_collision = 13
	body.set_collision_mask_bit(target_collision, true) # sets the appropriate collision mask
	for i in range(11,13):
		if i != target_collision:
			body.set_collision_mask_bit(i, false) # removes other collision masks
	
	if body.name == "Player" or body.name == "Player2": # if the Player changes floors...
		for e in get_tree().get_nodes_in_group("Enemies"):
			Enemy.set_player_collision(e) # ...places enemies on "Enemy" collision layer if z_index matches player's
	else: # if it wasn't the player that changed floors, update the body (the enemy) only
		Enemy.set_player_collision(body)

func enable_exits(value):
	print('enable_exits: ', value)
	var opposite = false if value else true
	for p in get_tree().get_nodes_in_group("Players"):
		p.set_collision_mask_bit(10, value)
	for e in get_tree().get_nodes_in_group("Exits"):
		e.set_collision_mask_bit(0, opposite)
