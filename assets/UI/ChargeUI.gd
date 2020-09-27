extends Control

onready var progress = $TextureProgress
onready var animation = $TextureProgress/AnimationPlayer

var currentCharge setget set_charge

func set_charge(value):
	currentCharge = value
	progress.value = currentCharge
	if currentCharge >= PlayerStats.max_charge:
		animation.play("RedFlash")
	else:
		animation.stop()
	
func _ready():
	self.currentCharge = PlayerStats.charge
	PlayerStats.connect("charge_changed", self, "set_charge")

