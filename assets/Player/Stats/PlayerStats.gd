extends Node

var acceleration = 800
var max_speed = 100
var speed_mod = 0 setget set_speed_mod
var roll_speed = 200
var shade_speed = 420
var friction = 800
var shade_friction = 840
var dir_vector = Vector2.DOWN
var affinity = 0

var vitality = 12 setget set_vitality
var endurance = 12 setget set_endurance
var defense = 4.0 setget set_defense
var strength = 4.0 setget set_strength
var dexterity = 4.0 setget set_dexterity
var speed = 4.0 setget set_speed
var magic = 4.0 setget set_magic

var level = 1 setget set_level
var experience = 82 setget set_experience
var experience_required = 100 setget set_max_experience
var experience_total = 82

var max_health = vitality*15 setget set_max_health
var health = max_health setget set_health
var old_health = health
var final_health setget set_final_health
var dying = false setget set_dying
var dead = false setget set_dead
var continue_count = 0

var max_stamina = endurance*15 setget set_max_stamina
var stamina = max_stamina setget set_stamina
var stamina_regen_rate = 0.2 setget set_stamina_regen_rate
var stamina_attack_cost = 15

var strength_mod = 0 setget set_strength_mod
var defense_mod = 0 setget set_defense_mod
var status_resistance setget set_status_resistance
var dexterity_mod = 0.0 setget set_dexterity_mod
var base_accuracy = 75
var base_crit_rate = 4
var attack_speed = 1.0 setget set_attack_speed
var iframes = 0.1 setget set_iframes
var max_charge = 100 setget set_max_charge
var charge = 0 setget set_charge
var charge_rate = 0.5
var max_charge_level = 2 setget set_max_charge_level
var charge_level = 0 setget set_charge_level
var magic_mod = 1.0 setget set_magic_mod
var drop_rate_mod = 1.0 setget set_drop_rate_mod

var cash = 0 setget set_cash

var status = "fine" setget set_status
var sweating = false

var vitality_description = "Willpower is a measure of your ability to press on through hardship, or how much you are willing to withstand."
var endurance_description = "Lung Capacity determines how many physical actions you can perform in a short period of time."
var defense_description = "Resilience makes things easier for you when hardship is inevitable, as well as helps in maintaining your composure."
var strength_description = "Violent Nature is a measure of how much pain you are willing to inflict on others, for survival or otherwise."
var dexterity_description = "Patience allows for careful observation of threats, augmenting accuracy and the frequency of critical strikes."
var speed_description = "Swiftness aids in reflexive maneuvers like evasion, as well as the speed with which certain actions are performed."
var magic_description = "Spirituality governs the amount of aid received from higher planes, as well as one's grasp of the incomprehensible."

signal no_health
signal vitality_changed(value)
signal health_changed(value)
signal max_health_changed(value)
signal final_health_changed(value)
signal player_dying(value)
signal endurance_changed(value)
signal stamina_changed(value)
signal max_stamina_changed(value)
signal stamina_regen_rate_changed(value)
signal strength_changed(value)
signal strength_mod_changed(value)
signal dexterity_changed(value)
signal dexterity_mod_changed(value)
signal defense_changed(value)
signal defense_mod_changed(value)
signal iframes_changed(value)
signal speed_changed(value)
signal attack_speed_changed(value)
signal magic_changed(value)
# signal magic_mod_changed(value)
signal status_changed(value)

signal max_charge_changed(value)
signal charge_changed(value)

signal max_charge_level_changed(value)
signal charge_level_changed(value)

signal experience_changed(value)
signal max_experience_changed(value)
signal level_changed(value)
signal cash_changed(value)

func _ready():
	self.acceleration = acceleration
	self.max_speed = max_speed
	self.speed_mod = speed_mod
	self.roll_speed = roll_speed
	self.shade_speed = shade_speed
	self.friction = friction
	self.shade_friction = shade_friction
	# self.vitality = vitality
	self.health = health
	# self.endurance = endurance
	self.stamina = max_stamina
	self.defense = defense
	self.strength = strength
	self.dexterity = dexterity
	self.speed = speed
	self.magic = magic
	self.iframes = iframes
	# self.attack_speed = attack_speed
	self.experience = experience_total
	self.cash = cash
	self.status = status
	self.charge = charge
	self.charge_level = charge_level

func default_stats():
	self.vitality = 4
	self.max_health = 60
	self.health = 60
	self.endurance = 4
	self.max_stamina = 60
	self.stamina = 60
	self.defense = 4
	self.strength = 4
	self.dexterity = 4
	self.speed = 4
	self.magic = 4
	self.level = 1
	self.experience = 0
	self.experience_required = 100
	self.experience_total = 0

func set_status(value):
	status = value
	match status:
		"fine":
			speed_mod = 0
		"slow":
			speed_mod = -max_speed/2
		"default_speed":
			speed_mod = 0
			
	emit_signal("status_changed", status)

func set_speed_mod(value):
	speed_mod = value

func increment_vitality():
	self.vitality += 1
	var health_increase
	if vitality > 30:
		health_increase = 1
	elif vitality > 20:
		health_increase = 3
	elif vitality > 10:
		health_increase = 6
	elif vitality <= 10:
		health_increase = 9
	self.max_health += health_increase
	self.health += health_increase

func set_vitality(value):
	vitality = value
	emit_signal("vitality_changed", vitality)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	old_health = health
	health = value
	health = clamp(value, 0, max_health)
	if health <= 0 && !dying:
		set_dying(true)
		
	elif dying && value > 0:
		set_dying(false)
		
	emit_signal("health_changed", health) # every time the health is set, emits a signal "health_changed" along with an argument, our new health value

func set_final_health(value):
	final_health = value
	emit_signal("final_health_changed", final_health)

func set_dying(value):
	dying = value
	if value:
		# self.stamina = 0
		self.status = "slow"
		# self.status = "sweating"
	else:
		self.status = "default_speed"
	
	emit_signal("player_dying", value)

func set_dead(value):
	dead = value
	if dead:
		emit_signal("no_health")
		# print('setting dead')

func increment_endurance():
	self.endurance += 1
	var stamina_increase
	if endurance > 30:
		stamina_increase = 1
	elif endurance > 20:
		stamina_increase = 3
	elif endurance > 10:
		stamina_increase = 6
	elif endurance <= 10:
		stamina_increase = 9
	self.max_stamina += stamina_increase
	self.stamina += stamina_increase

func set_endurance(value):
	endurance = value
	emit_signal("endurance_changed", endurance)

func set_max_stamina(value):
	max_stamina = value
	emit_signal("max_stamina_changed", max_stamina)

func set_stamina(value):
	stamina = value
	stamina = clamp(value, -15, max_stamina)
	emit_signal("stamina_changed", stamina)

func set_stamina_regen_rate(value):
	stamina_regen_rate = value
	emit_signal("stamina_regen_rate_changed", stamina_regen_rate)

func set_defense(value):
	defense = value
	self.status_resistance = defense/128
	emit_signal("defense_changed", defense)

func set_defense_mod(value):
	defense_mod = value
	emit_signal("defense_mod_changed", defense_mod)

func set_status_resistance(value):
	status_resistance = value
	# print('status_resistance set: ', status_resistance)

func set_strength(value):
	# print('strength set: ', value)
	strength = value
	emit_signal("strength_changed", strength)

func set_strength_mod(value):
	strength_mod = value
	emit_signal("strength_mod_changed", strength_mod)

func set_dexterity(value):
	dexterity = value
	emit_signal("dexterity_changed", dexterity)

func set_dexterity_mod(value):
	dexterity_mod = value
	emit_signal("dexterity_mod_changed", dexterity_mod)

func set_speed(value):
	speed = value
	self.attack_speed = 1 + (speed / 120)
	charge_rate = 0.5 + (speed / 120)
	emit_signal("speed_changed", speed)

func set_attack_speed(value):
	attack_speed = value
	emit_signal("attack_speed_changed", attack_speed)

func set_iframes(value):
	iframes = value
	emit_signal("iframes_changed", iframes)

func set_max_charge(value):
	max_charge = value
	emit_signal("max_charge_changed", max_charge)

func set_charge(value):
	charge = value
	emit_signal("charge_changed", charge)

func set_max_charge_level(value):
	max_charge_level = value
	emit_signal("max_charge_level_changed", max_charge_level)

func set_charge_level(value):
	charge_level = value
	emit_signal("charge_level_changed", charge_level)

func set_magic(value):
	magic = value
	self.magic_mod = 1 + (magic / 32) # + ~3.125% per point
	self.drop_rate_mod = 1 + (magic / 64) # + ~1.5625% per point
	emit_signal("magic_changed", magic)

func set_magic_mod(value):
	magic_mod = value
	# print('magic mod set: ', magic_mod)
	# emit_signal("magic_mod_changed", magic_mod)

func set_drop_rate_mod(value):
	drop_rate_mod = value
	# print('luck bonus set: ', drop_rate_mod)
	# emit_signal("drop_rate_mod_changed")

func set_max_experience(value):
	experience_required = value
	emit_signal("max_experience_changed", experience_required)

func set_experience(value):
	experience = value
	emit_signal("experience_changed", experience)

func set_level(value):
	level = value
	emit_signal("level_changed", level)

func set_cash(value):
	cash = value
	emit_signal("cash_changed", cash)
