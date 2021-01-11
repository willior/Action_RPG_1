extends Control

var currentHealth setget set_health
var currentMax_health setget set_max_health
var currentEndurance setget set_endurance
var currentDefense setget set_defense
var currentStrength setget set_strength
var currentDexterity setget set_dexterity
var currentSpeed setget set_speed

onready var healthBox = $Vbox/vit
onready var enduranceBox = $Vbox/end
onready var defenseBox = $Vbox/def
onready var strengthBox = $Vbox/str
onready var dexterityBox = $Vbox/dex
onready var speedBox = $Vbox/spd

func set_max_health(value):
	currentMax_health = str(value / 15)
	healthBox.set_text("VIT " + (currentMax_health))

func set_health(value):
	currentHealth = str(value)
	# healthBox.set_text("VIT " + (currentHealth))

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
	self.currentMax_health = PlayerStats.max_health
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_health_changed", self, "set_max_health")
	self.currentEndurance = PlayerStats.endurance
# warning-ignore:return_value_discarded
	PlayerStats.connect("endurance_changed", self, "set_endurance")
	self.currentDefense = PlayerStats.defense
# warning-ignore:return_value_discarded
	PlayerStats.connect("defense_changed", self, "set_defense")
	self.currentStrength = PlayerStats.strength
# warning-ignore:return_value_discarded
	PlayerStats.connect("strength_changed", self, "set_strength")
	self.currentDexterity = PlayerStats.dexterity
# warning-ignore:return_value_discarded
	PlayerStats.connect("dexterity_changed", self, "set_dexterity")
	self.currentSpeed = PlayerStats.speed
# warning-ignore:return_value_discarded
	PlayerStats.connect("speed_changed", self, "set_speed")
