extends Control


var currentEndurance setget set_endurance
var currentStrength setget set_strength
var currentSpeed setget set_speed


onready var enduranceBox = $Vbox/end
onready var strengthBox = $Vbox/str
onready var speedBox = $Vbox/spd


func set_endurance(value):
	currentEndurance = str(value)
	enduranceBox.set_text("END " + currentEndurance)

func set_strength(value):
	currentStrength = str(value)
	strengthBox.set_text("STR " + currentStrength)
	
func set_speed(value):
	currentSpeed = str(value)
	speedBox.set_text("SPD " + currentSpeed)
	
func _ready():
	
	self.currentEndurance = PlayerStats.endurance
# warning-ignore:return_value_discarded
	PlayerStats.connect("endurance_changed", self, "set_endurance")
	self.currentStrength = PlayerStats.strength
# warning-ignore:return_value_discarded
	PlayerStats.connect("strength_changed", self, "set_strength")
	self.currentSpeed = PlayerStats.speed
# warning-ignore:return_value_discarded
	PlayerStats.connect("speed_changed", self, "set_speed")
