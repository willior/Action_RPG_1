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
	stamBar.rect_min_size.x = max_stamina/3

func _ready():
#	if !GameManager.multiplayer_2:
#		queue_free()
#		return
	self.max_stamina = Player2Stats.max_stamina
	self.stamina = Player2Stats.stamina
# warning-ignore:return_value_discarded
	Player2Stats.connect("stamina_changed", self, "set_stamina")
# warning-ignore:return_value_discarded
	Player2Stats.connect("max_stamina_changed", self, "set_max_stamina")
# warning-ignore:return_value_discarded
	Player2Stats.connect("status_changed", self, "set_sweating")

func set_sweating(value):
	match value:
		"sweating":
			$AnimationPlayer.play("Sweating")
		"sweating_end":
			$AnimationPlayer.play("Stop")
