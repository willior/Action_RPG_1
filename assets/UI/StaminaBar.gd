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
	stamBar.rect_size.x = max_stamina/3

func _ready():
	self.max_stamina = Player1Stats.max_stamina
	self.stamina = Player1Stats.stamina
# warning-ignore:return_value_discarded
	Player1Stats.connect("stamina_changed", self, "set_stamina")
# warning-ignore:return_value_discarded
	Player1Stats.connect("max_stamina_changed", self, "set_max_stamina")
# warning-ignore:return_value_discarded
	Player1Stats.connect("sweating_changed", self, "set_sweating")

func set_sweating(value):
	if value:
		$AnimationPlayer.play("Sweating")
	else:
		$AnimationPlayer.play("Stop")
