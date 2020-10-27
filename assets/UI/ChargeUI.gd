extends Node2D

onready var progress1 = $TextureProgress1
onready var animation1 = $TextureProgress1/AnimationPlayer
onready var progress2 = $TextureProgress2
onready var animation2 = $TextureProgress2/AnimationPlayer
onready var staminaProgress = $StaminaProgress
onready var c = $C
onready var d = $D

onready var chargeSound1 = $ChargeSound1
onready var chargeSound2 = $ChargeSound2

var currentCharge = 0 setget set_charge
var currentChargeLevel = 0 setget set_charge_level

var currentStamina = PlayerStats.stamina setget set_stamina
var currentMaxStamina = PlayerStats.max_stamina setget set_max_stamina

func _ready():
	PlayerStats.charge = 0
	PlayerStats.charge_level = 0
	self.currentMaxStamina = PlayerStats.max_stamina
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_stamina_changed", self, "set_max_stamina")
	self.currentStamina = PlayerStats.stamina
# warning-ignore:return_value_discarded
	PlayerStats.connect("stamina_changed", self, "set_stamina")
	self.currentCharge = PlayerStats.charge
# warning-ignore:return_value_discarded
	PlayerStats.connect("charge_changed", self, "set_charge")
	self.currentChargeLevel = PlayerStats.charge_level
# warning-ignore:return_value_discarded
	PlayerStats.connect("charge_level_changed", self, "set_charge_level")

func set_stamina(value):
	currentStamina = value
	staminaProgress.value = currentStamina
	
func set_max_stamina(value):
	currentMaxStamina = value
	staminaProgress.max_value = currentMaxStamina

func begin_charge_1():
	chargeSound2.play()
	progress1.visible = true
	staminaProgress.visible = true
	
func begin_charge_2():
	chargeSound2.play()
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
	currentChargeLevel = value
	if currentChargeLevel == 1:
		c.play()	
	elif currentChargeLevel == 2:
		d.play()

func stop_charge():
	chargeSound1.stop()
	chargeSound2.stop()
	staminaProgress.visible = false
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
