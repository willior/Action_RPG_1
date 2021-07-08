extends Node

var acceleration = 800
var max_speed = 100
var max_speed_mod = 0 setget set_max_speed_mod
var roll_speed = 200
var shade_speed = 420
var friction = 1200
var shade_friction = 840
var dir_vector = Vector2.DOWN
var affinity = 0

var vitality = 32 setget set_vitality
var endurance = 32 setget set_endurance
var defense: float = 12.0 setget set_defense
var strength: float = 12.0 setget set_strength
var dexterity: float = 12.0 setget set_dexterity
var speed: float = 12.0 setget set_speed
var magic: float = 12.0 setget set_magic

var level = 1 setget set_level
var experience = 82 setget set_experience
var experience_required = 100 setget set_max_experience
var experience_total = 82
var leveling = false setget set_leveling

var weapon_level = 1 setget set_weapon_level
var weapon_xp = 0
var weapon_xp_required = 100
var weapon_xp_total = 0
var weapon_growth_rate = 50

var max_charge = weapon_level*50 setget set_max_charge
var charge = 0 setget set_charge
var charge_level = 0 setget set_charge_level

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

var strength_mod : float = 1 setget set_strength_mod
var attack_power setget set_attack_power

var defense_mod : float = 1 setget set_defense_mod
var status_resistance setget set_status_resistance

var dexterity_mod : float = 1 setget set_dexterity_mod
var dexterity_bonus = 0 setget set_dexterity_bonus
var base_accuracy = 75
var base_crit_rate = 4
var accuracy setget set_accuracy
var crit_rate setget set_crit_rate

var speed_mod : float = 1 setget set_speed_mod
var evasion
var evasion_action_bonus = 0 setget set_evasion_action_bonus
var iframes = 0.1
var charge_rate = 0.5
var attack_speed = 1.0 setget set_attack_speed

var magic_mod : float = 1 setget set_magic_mod
var spell_mod = 1.0 setget set_spell_mod
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
signal health_changed(value)
signal max_health_changed(value)
signal final_health_changed(value)
signal player_dying(value)
signal stamina_changed(value)
signal max_stamina_changed(value)
signal attack_power_changed(value)
signal attack_speed_changed(value)
signal status_changed(value)
signal max_charge_changed(value)
signal charge_changed(value)
signal charge_level_changed(value)
signal experience_changed(value)
signal max_experience_changed(value)
signal level_changed(value)
signal player_leveling(value)
signal cash_changed(value)

func _ready():
	self.vitality = vitality
	self.endurance = endurance
	self.defense = defense
	self.strength = strength
	self.dexterity = dexterity
	self.speed = speed
	self.magic = magic

func reset_stats():
	self.vitality = 40
	self.max_health = 999
	self.health = 999
	self.endurance = 40
	self.max_stamina = 999
	self.stamina = 999
	self.defense = 40.0
	self.strength = 40.0
	self.dexterity = 40.0
	self.speed = 40.0
	self.magic = 40.0
	self.defense_mod = 1
	self.strength_mod = 1
	self.dexterity_mod = 1
	self.speed_mod = 1
	self.magic_mod = 1
	self.level = 1
	self.experience = 0
	self.experience_required = 100
	self.experience_total = 0
	self.weapon_xp = 0
	self.weapon_xp_required = 100
	self.weapon_xp_total = 0
	self.weapon_level = 1
	self.dying = false
	self.dead = false

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
	self.defense_mod = 1
	self.strength_mod = 1
	self.dexterity_mod = 1
	self.speed_mod = 1
	self.magic_mod = 1
	self.level = 1
	self.experience = 0
	self.experience_required = 100
	self.experience_total = 0
	self.weapon_xp = 0
	self.weapon_xp_required = 100
	self.weapon_xp_total = 0
	self.weapon_level = 1
	self.dying = false
	self.dead = false

func recovery():
	self.health = max_health
	self.stamina = max_stamina

func set_status(value):
	status = value
	emit_signal("status_changed", status)

func set_max_speed_mod(value):
	max_speed_mod = value

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
	# emit_signal("vitality_changed", vitality)

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
	emit_signal("player_dying", value)

func set_dead(value):
	dead = value
	if dead:
		emit_signal("no_health")

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

func set_max_stamina(value):
	max_stamina = value
	emit_signal("max_stamina_changed", max_stamina)

func set_stamina(value):
	stamina = value
	stamina = clamp(value, -15, max_stamina)
	emit_signal("stamina_changed", stamina)

func set_stamina_regen_rate(value):
	stamina_regen_rate = value

func set_defense(value):
	defense = value
	status_resistance = defense/128

func set_defense_mod(value):
	defense_mod = value

func set_status_resistance(value):
	status_resistance = value

func set_strength(value):
	strength = value
	self.attack_power = strength * strength_mod

func set_strength_mod(value):
	strength_mod = value
	set_strength(strength)

func set_attack_power(value):
	attack_power = value
	emit_signal("attack_power_changed", attack_power)

func set_dexterity(value):
	dexterity = value
	self.accuracy = base_accuracy + 2*(dexterity * dexterity_mod + dexterity_bonus)
	self.crit_rate = base_crit_rate + (dexterity * dexterity_mod + dexterity_bonus)/4

func set_dexterity_mod(value):
	dexterity_mod = value
	set_dexterity(dexterity)

func set_dexterity_bonus(value):
	dexterity_bonus = value
	set_dexterity(dexterity)

func set_accuracy(value):
	accuracy = value

func set_crit_rate(value):
	crit_rate = value

func set_speed(value):
	speed = value
	evasion = (speed / 2 + evasion_action_bonus) * speed_mod
	max_speed = (100 + (speed / 2)) * speed_mod
	roll_speed = (200 + speed) * speed_mod
	shade_speed = (420 + (speed * 3)) * speed_mod
	charge_rate = (0.5 + (speed / 128)) * speed_mod
	iframes = (0.1 + (speed / 128)) * speed_mod
	self.attack_speed = (1 + (speed / 128)) * speed_mod

func set_speed_mod(value):
	speed_mod = value
	set_speed(speed)

func set_evasion_action_bonus(value):
	evasion_action_bonus = value
	evasion = (speed / 2 + evasion_action_bonus) * speed_mod

func set_attack_speed(value):
	attack_speed = value
	emit_signal("attack_speed_changed", attack_speed)

func set_magic(value):
	magic = value
	spell_mod = 1 + (magic / 32) # + ~3.125% per point
	drop_rate_mod = 1 + (magic / 64) # + ~1.5625% per point

func set_magic_mod(value):
	magic_mod = value
	set_magic(magic)

func set_spell_mod(value):
	spell_mod = value

func set_drop_rate_mod(value):
	drop_rate_mod = value

func set_max_experience(value):
	experience_required = value
	emit_signal("max_experience_changed", experience_required)

func set_experience(value):
	experience = value
	emit_signal("experience_changed", experience)

func set_level(value):
	level = value
	emit_signal("level_changed", level)

func set_leveling(value):
	leveling = value
	emit_signal("player_leveling", value)

func apply_weapon_xp(who):
	weapon_xp += weapon_growth_rate
	weapon_xp_total += weapon_growth_rate
	while weapon_xp >= weapon_xp_required:
		self.weapon_level += 1
		weapon_xp -= weapon_xp_required
		weapon_xp_required *= 1.2
		weapon_xp_required = round(weapon_xp_required)
		Global.display_message_popup(who, "Sword is now level " + str(weapon_level), "level")

func set_weapon_level(value):
	weapon_level = value
	self.max_charge = weapon_level*50
	print("weapon_level charnged: max_charge = ", max_charge)

func set_max_charge(value):
	max_charge = value
	emit_signal("max_charge_changed", max_charge)

func set_charge(value):
	charge = min(value, max_charge)
	emit_signal("charge_changed", charge)

func set_charge_level(value):
	charge_level = value
	emit_signal("charge_level_changed", charge_level)

func set_cash(value):
	cash = value
	emit_signal("cash_changed", cash)
