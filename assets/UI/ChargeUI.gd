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

var stats

var currentCharge = 0 setget set_charge
var currentChargeLevel = 0 setget set_charge_level

var currentStamina setget set_stamina
var currentMaxStamina setget set_max_stamina
var staminaPercent = 1
var staminaWarning = false
var sweatFlag = false

func _ready():
	stats = get_parent().stats
	stats.charge = 0
	stats.charge_level = 0
	self.currentMaxStamina = stats.max_stamina
# warning-ignore:return_value_discarded
	stats.connect("max_stamina_changed", self, "set_max_stamina")
	self.currentStamina = stats.stamina
# warning-ignore:return_value_discarded
	stats.connect("stamina_changed", self, "set_stamina")
	self.currentCharge = stats.charge
# warning-ignore:return_value_discarded
	stats.connect("charge_changed", self, "set_charge")
	self.currentChargeLevel = stats.charge_level
# warning-ignore:return_value_discarded
	stats.connect("charge_level_changed", self, "set_charge_level")

func set_stamina(value):
	currentStamina = value
	staminaProgress.value = currentStamina
	staminaPercent = currentStamina / currentMaxStamina
	# fade in stamina progress (not sweating)
	if !staminaProgress.visible && staminaPercent < 1 && !get_parent().sweating:
		staminaProgress.visible = true
		$Tween.interpolate_property(staminaProgress,
		"modulate",
		Color(1, 1, 1, 0),
		Color(1, 1, 1, 0.6),
		0.3,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
		)
		$Tween.start()
	# fade in stamina progress (sweating)
	elif !staminaProgress.visible && staminaPercent >= 0 && get_parent().sweating:
		# sweatFlag = false
		staminaProgress.visible = true
		$Tween.interpolate_property(staminaProgress,
		"modulate",
		Color(1, 1, 1, 0),
		Color(1, 1, 1, 0.6),
		0.3,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
		)
		$Tween.start()
	# fade out stamina progress (100% stamina)
	elif staminaProgress.visible && (staminaPercent == 1):
		$Tween.interpolate_property(staminaProgress,
		"modulate",
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 0),
		0.3,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
		)
		$Tween.start()
		yield($Tween, "tween_all_completed")
		staminaProgress.visible = false
	# fade out stamina progress (0% stamina)
	elif sweatFlag && (staminaPercent <= 0 && get_parent().sweating):
		sweatFlag = false
		$Tween.interpolate_property(staminaProgress,
		"modulate",
		Color(1, 1, 1, 0.6),
		Color(1, 1, 1, 0),
		0.3,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
		)
		$Tween.start()
		yield($Tween, "tween_all_completed")
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
	if value:
		staminaWarning = true
		staminaWarningAnimation.play("On")
	else:
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
	
	if currentCharge > 50 && stats.charge_level == 0:
		stats.charge_level = 1
		begin_charge_2()
		
	if currentCharge >= 100 && stats.charge_level == 1:
		stats.charge_level = 2

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
