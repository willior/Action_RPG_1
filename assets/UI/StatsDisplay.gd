extends Control
var currentVitality = str(PlayerStats.vitality) setget set_vitality
var currentHealth = str(PlayerStats.health) setget set_health
var currentMax_health = str(PlayerStats.max_health) setget set_max_health
var currentEndurance = str(PlayerStats.endurance) setget set_endurance
var currentDefense = str(PlayerStats.defense) setget set_defense
var currentStrength = str(PlayerStats.strength) setget set_strength
var currentDexterity = str(PlayerStats.dexterity) setget set_dexterity
var currentSpeed = str(Player2Stats.speed) setget set_speed

onready var healthBox = $Vbox/vit
onready var enduranceBox = $Vbox/end
onready var defenseBox = $Vbox/def
onready var strengthBox = $Vbox/str
onready var dexterityBox = $Vbox/dex
onready var speedBox = $Vbox/spd

func set_vitality(value):
	currentVitality = str(value)
	healthBox.set_text("VIT " + currentVitality + " (" + currentHealth + "/" + currentMax_health + ")")

func set_max_health(value):
	currentMax_health = str(value)
	healthBox.set_text("VIT " + currentVitality + " (" + currentHealth + "/" + currentMax_health + "HP)")

func set_health(value):
	currentHealth = str(value)
	healthBox.set_text("VIT " + currentVitality + " (" + currentHealth + "/" + currentMax_health + "HP)")
	
func set_vitality_stat_display(vitality, health, max_health):
	healthBox.set_text("VIT " + vitality + " (" + health + "/" + max_health + "HP)")

func set_endurance(value):
	currentEndurance = str(value)
	enduranceBox.set_text("END " + currentEndurance)
	
func set_defense(value):
	currentDefense = str(value)
	defenseBox.set_text("DEF " + currentDefense)

func set_strength(value):
	currentStrength = str(value)
	strengthBox.set_text("STR " + currentStrength)
	
func set_dexterity(value):
	currentDexterity = str(value)
	dexterityBox.set_text("DEX " + currentDexterity)
	
func set_speed(value):
	currentSpeed = str(value)
	speedBox.set_text("SPD " + currentSpeed)
	
func _ready():
# warning-ignore:return_value_discarded
	PlayerStats.connect("vitality_changed", self, "set_vitality")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_health_changed", self, "set_max_health")
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed", self, "set_health")
# warning-ignore:return_value_discarded
	PlayerStats.connect("endurance_changed", self, "set_endurance")
# warning-ignore:return_value_discarded
	PlayerStats.connect("defense_changed", self, "set_defense")
# warning-ignore:return_value_discarded
	PlayerStats.connect("strength_changed", self, "set_strength")
# warning-ignore:return_value_discarded
	PlayerStats.connect("dexterity_changed", self, "set_dexterity")
# warning-ignore:return_value_discarded
	PlayerStats.connect("speed_changed", self, "set_speed")
	self.currentVitality = PlayerStats.vitality
	self.currentMax_health = PlayerStats.max_health
	self.currentHealth = PlayerStats.health
	self.currentEndurance = PlayerStats.endurance
	self.currentDefense = PlayerStats.defense
	self.currentStrength = PlayerStats.strength
	self.currentDexterity = PlayerStats.dexterity
	self.currentSpeed = PlayerStats.speed
