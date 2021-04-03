extends Node

const BloodHitEffect = preload("res://assets/Effects/Blood_HitEffect.tscn")

var player1
var player2
var chapter_display
var chapter_name
var custom_variables = {}
var dialogOpen = false
var changingScene = false
var _attributes = null
var current_scene = null
var in_cutscene = false
var rng = RandomNumberGenerator.new()

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )
	rng.randomize()
		
func update_player():
	player1 = get_node("/root/World/YSort/Player")
	if GameManager.multiplayer_2:
		player2 = get_node("/root/World/YSort/Player2")
		
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
	
func player_hit_calculation(base_accuracy, dexterity, modifier, evasion):
	rng.randomize()
	var random_value = rng.randf_range(0, 100)
	var base_hit_rate = base_accuracy + (2*(dexterity+modifier))
	var final_hit_rate = base_hit_rate - evasion
	# print("player final_hit_rate: ", final_hit_rate, "% > ", "RNG: ", random_value)
	if final_hit_rate >= random_value:
		return true
	elif final_hit_rate < random_value:
		return false
		
func enemy_hit_calculation(base_accuracy, accuracy, evasion):
	rng.randomize()
	var random_value = rng.randf_range(0, 100)
	var base_hit_rate = base_accuracy + (4*accuracy)
	var final_hit_rate = base_hit_rate - (evasion)
	# print("enemy final_hit_rate: ", final_hit_rate, "% > ", "RNG: ", random_value)
	if final_hit_rate >= random_value:
		return true
	elif final_hit_rate < random_value:
		return false
		
func crit_calculation(base_crit_rate, dexterity, dexterity_mod):
	rng.randomize()
	var random_value = rng.randf_range(0, 100)
	var final_crit_rate = base_crit_rate + (dexterity/4) + (dexterity_mod/2)
	# print("crit calculation: ", final_crit_rate, "% > ", "RNG: ", random_value)
	if final_crit_rate >= random_value:
		SoundPlayer.play_sound("crit")
		return true
	elif final_crit_rate < random_value:
		return false
	
func damage_calculation(attack, defense, random):
	var base_damage = 2 * (attack*attack / (attack+defense))
	#print('[[[ attack = ', attack, " vs. ", "defense = ", defense)
	#print("base damage = ", "2 * (", attack*attack, " / ", attack+defense, ") = ", base_damage, " ]]]")
	return random_variance(base_damage, random)
	
func random_variance(base_damage, random):
	rng.randomize()
	var random_value = rng.randf_range(1-random, 1+random)
	return int(base_damage * random_value)

func distribute_exp(value):
	#PlayerStats.experience += value
	#Player2Stats.experience += value
	var experience_gained = value
	if GameManager.multiplayer_2:
		experience_gained /= 2
		get_node("/root/World/YSort/Player").enemy_killed(experience_gained)
		get_node("/root/World/YSort/Player2").enemy_killed(experience_gained)
	else:
		get_node("/root/World/YSort/Player").enemy_killed(experience_gained)
		
func create_blood_effect(damage_count, location):
	randomize()
	var blood_effect = BloodHitEffect.instance()
	var randX = int(rand_range(-damage_count, damage_count))
	var randY = int(rand_range(-damage_count/2, damage_count))
	blood_effect.global_position = location
	blood_effect.target_position = location + Vector2(randX, randY)
	# get_parent().add_child(blood_effect)
	get_node("/root/World/Map").add_child(blood_effect)
	
func reset_input_after_dialog():
	update_player()
	player1.check_attack_input()
