extends Node2D

onready var progress1 = $TextureProgress1
onready var animation1 = $TextureProgress1/AnimationPlayer
onready var progress2 = $TextureProgress2
onready var animation2 = $TextureProgress2/AnimationPlayer
onready var staminaProgress = $StaminaProgress
onready var staminaWarningAnimation = $StaminaProgress/AnimationPlayer
onready var chargeBeep1 = $ChargeBeep1
onready var chargeBeep2 = $ChargeBeep2
onready var chargeSound1 = $ChargeSound1
onready var chargeSound2 = $ChargeSound2

var currentCharge = 0 setget set_charge
var currentChargeLevel = 0 setget set_charge_level

var currentStamina = Player2Stats.stamina setget set_stamina
var currentMaxStamina = Player2Stats.max_stamina setget set_max_stamina
var staminaPercent = 1
var staminaWarning = false

func _ready():
	Player2Stats.charge = 0
	Player2Stats.charge_level = 0
	self.currentMaxStamina = Player2Stats.max_stamina
# warning-ignore:return_value_discarded
	Player2Stats.connect("max_stamina_changed", self, "set_max_stamina")
	self.currentStamina = Player2Stats.stamina
# warning-ignore:return_value_discarded
	Player2Stats.connect("stamina_changed", self, "set_stamina")
	self.currentCharge = Player2Stats.charge
# warning-ignore:return_value_discarded
	Player2Stats.connect("charge_changed", self, "set_charge")
	self.currentChargeLevel = Player2Stats.charge_level
# warning-ignore:return_value_discarded
	Player2Stats.connect("charge_level_changed", self, "set_charge_level")

func set_stamina(value):
	currentStamina = value
	staminaProgress.value = currentStamina
	
	staminaPercent = currentStamina / currentMaxStamina
	# call_deferred("staminaPercent = currentStamina / currentMaxStamina")
	
	if !staminaProgress.visible && staminaPercent < 1:
		staminaProgress.visible = true
	elif staminaProgress.visible && (staminaPercent == 1 || (staminaPercent <= 0 && Player2Stats.status == "sweating")):
		staminaProgress.visible = false

	if staminaPercent < 0.25 && staminaPercent != 0 && !staminaWarning:
		toggle_stamina_warning(true)
	elif staminaPercent > 0.25 && staminaWarning:
		toggle_stamina_warning(false)
	elif staminaPercent < 0.25 && staminaWarning:
		staminaWarningAnimation.playback_speed = 4 - staminaPercent*12
	
func set_max_stamina(value):
	currentMaxStamina = value
	staminaProgress.max_value = currentMaxStamina
	
func toggle_stamina_warning(value):
	match value:
		true:
			staminaWarning = true
			staminaWarningAnimation.play("On")
		false:
			staminaWarning = false
			staminaWarningAnimation.play("Off")

func begin_charge_1():
	chargeSound2.play()
	progress1.visible = true
	# staminaProgress.visible = true
	
func begin_charge_2():
	chargeSound2.play()
	progress2.visible = true

func set_charge(value):
	currentCharge = value
	
	if currentChargeLevel == 0:
		progress1.value = currentCharge
	elif currentChargeLevel == 1:
		progress2.value = currentCharge
	
	if currentCharge > 50 && Player2Stats.charge_level == 0:
		Player2Stats.charge_level = 1
		begin_charge_2()
		
	if currentCharge >= 100 && Player2Stats.charge_level == 1:
		Player2Stats.charge_level = 2

	# if currentCharge == Player2Stats.max_charge:
		# if currentChargeLevel == 0:
			# animation1.play("ChargeFlash")
			
		# elif currentChargeLevel == 1:
			# animation2.play("ChargeFlash")
		
func set_charge_level(value):
	currentChargeLevel = value
	if currentChargeLevel == 1:
		chargeBeep1.play()
	elif currentChargeLevel == 2:
		chargeBeep2.play()

func stop_charge():
	chargeSound1.stop()
	chargeSound2.stop()
	# staminaProgress.visible = false
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
