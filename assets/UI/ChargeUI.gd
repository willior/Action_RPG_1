extends Control

onready var progress1 = $TextureProgress1
onready var animation1 = $TextureProgress1/AnimationPlayer
onready var progress2 = $TextureProgress2
onready var animation2 = $TextureProgress2/AnimationPlayer

onready var chargeSound = $ChargeSound

# onready var player = get_parent().get_parent().get_node("YSort/Player")

var currentCharge = 0 setget set_charge
var currentChargeLevel = 0 setget set_charge_level

func _ready():
	self.currentCharge = PlayerStats.charge
	PlayerStats.connect("charge_changed", self, "set_charge")
	self.currentChargeLevel = PlayerStats.charge_level
	PlayerStats.connect("charge_level_changed", self, "set_charge_level")

func begin_charge_1():
	print('beginning charge 1')
	chargeSound.play()
	progress1.visible = true
	
func begin_charge_2():
	print('beginning charge 2')
	chargeSound.play()
	progress2.visible = true

func set_charge(value):
	currentCharge = value
	
	if currentChargeLevel == 0:
		progress1.value = currentCharge
	elif currentChargeLevel == 1:
		progress2.value = currentCharge
	
	if currentCharge > 50 && PlayerStats.charge_level == 0:
		PlayerStats.charge_level = 1
		begin_charge_2()
		
	if currentCharge == 100 && PlayerStats.charge_level == 1:
		PlayerStats.charge_level = 2

	# if currentCharge == PlayerStats.max_charge:
		# if currentChargeLevel == 0:
			# animation1.play("ChargeFlash")
			
		# elif currentChargeLevel == 1:
			# animation2.play("ChargeFlash")
		
func set_charge_level(value):
	prints("charge level set: " + str(value))
	currentChargeLevel = value

func stop_charge():
	chargeSound.stop()
	progress1.visible = false
	progress2.visible = false
	currentCharge = 0
	progress1.value = currentCharge
	progress2.value = currentCharge
	# currentChargeLevel = 0
	# animation1.stop(true)
	# animation1.seek(0, true)
	# animation2.stop(true)
	# animation2.seek(0, true)
