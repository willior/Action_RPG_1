extends Control

onready var progress = $TextureProgress
onready var animation = $TextureProgress/AnimationPlayer

var currentCharge = 0 setget set_charge

func set_charge(value):
	currentCharge = value
	progress.value = currentCharge
	if currentCharge == PlayerStats.max_charge:
		print('playing charge animation')
		animation.play("ChargeFlash")
	else:
		print('stopping charge animation')
		animation.stop()
	
func _ready():
	self.currentCharge = PlayerStats.charge
	PlayerStats.connect("charge_changed", self, "set_charge")
