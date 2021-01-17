extends Control

var stamina setget set_stamina
var max_stamina setget set_max_stamina

onready var stamBar = $StaminaBarTexture

func set_stamina(value):
	stamina = value
	stamBar.value = stamina
	
func set_max_stamina(value):
	max_stamina = value
	stamBar.max_value = max_stamina
	stamBar.rect_size.x = max_stamina

func _ready():
	self.max_stamina = PlayerStats.max_stamina
	self.stamina = PlayerStats.stamina
# warning-ignore:return_value_discarded
	PlayerStats.connect("stamina_changed", self, "set_stamina")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_stamina_changed", self, "set_max_stamina")
# warning-ignore:return_value_discarded
	PlayerStats.connect("status_changed", self, "set_sweating")

func set_sweating(value):
	match value:
		"sweating":
			$AnimationPlayer.play("Sweating")
		"sweating_end":
			$AnimationPlayer.play("Stop")
