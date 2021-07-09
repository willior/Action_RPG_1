extends Node2D

const ChargeBeepAudio_1 = preload("res://assets/Audio/Player/Charge_Beep_1.wav")
const ChargeBeepAudio_2 = preload("res://assets/Audio/Player/Charge_Beep_2.wav")
const ChargeBeepAudio_3 = preload("res://assets/Audio/Player/Charge_Beep_3.wav")

onready var progress1 = $TextureProgress1
onready var animation1 = $TextureProgress1/AnimationPlayer
onready var progress2 = $TextureProgress2
onready var animation2 = $TextureProgress2/AnimationPlayer
onready var progress3 = $TextureProgress3
onready var animation3 = $TextureProgress3/AnimationPlayer
onready var staminaProgress = $StaminaProgress
onready var staminaWarningAnimation = $StaminaProgress/AnimationPlayer
onready var chargeBeep = $ChargeBeep
onready var chargeSound = $ChargeSound
onready var stats = get_parent().stats

var currentCharge = 0 setget set_charge
var currentChargeLevel = 0 setget set_charge_level

var currentStamina setget set_stamina
var currentMaxStamina setget set_max_stamina
var staminaPercent = 1
var staminaWarning = false
var sweatFlag = false

func _ready():
	stats.charge = 0
	stats.charge_level = 0
	self.currentMaxStamina = stats.max_stamina
	stats.connect("max_stamina_changed", self, "set_max_stamina")
	self.currentStamina = stats.stamina
	stats.connect("stamina_changed", self, "set_stamina")
	self.currentCharge = stats.charge
	stats.connect("charge_changed", self, "set_charge")
	self.currentChargeLevel = stats.charge_level
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
	chargeSound.play()
	progress1.visible = true
	
func begin_charge_2():
	chargeSound.play()
	progress2.visible = true

func begin_charge_3():
	chargeSound.play()
	progress3.visible = true

func set_charge(value):
	currentCharge = value
	if currentChargeLevel == 0:
		progress1.value = currentCharge
	if currentChargeLevel == 1:
		progress2.value = currentCharge
	if currentChargeLevel == 2:
		progress3.value = currentCharge

func set_charge_level(value):
	currentChargeLevel = value
	if currentChargeLevel == 1:
		chargeBeep.stream = ChargeBeepAudio_1
		chargeBeep.play()
	elif currentChargeLevel == 2:
		chargeBeep.stream = ChargeBeepAudio_2
		chargeBeep.play()
	elif currentChargeLevel == 3:
		chargeBeep.stream = ChargeBeepAudio_3
		chargeBeep.play()

func stop_charge():
	chargeSound.stop()
	progress1.visible = false
	progress2.visible = false
	progress3.visible = false
	currentCharge = 0
	progress1.value = currentCharge
	progress2.value = currentCharge
	progress3.value = currentCharge
