extends Control

var experienceProgress setget set_experience
var max_experience setget set_max_experience
var level setget set_level

onready var levelBox = $TextureRect/Label
onready var expBar = $ExpBarTexture

func set_experience(value):
	experienceProgress = value
	expBar.value = experienceProgress
	
func set_max_experience(value):
	max_experience = value
	expBar.max_value = max_experience
	
func set_level(value):
	level = value
	levelBox.set_text(str(Player2Stats.level))
	
func _ready():
	if !GameManager.multiplayer_2:
		queue_free()
		return
	self.max_experience = Player2Stats.experience_required
	self.experienceProgress = Player2Stats.experience
	self.level = Player2Stats.level
	
# warning-ignore:return_value_discarded
	Player2Stats.connect("experience_changed", self, "set_experience")
# warning-ignore:return_value_discarded
	Player2Stats.connect("max_experience_changed", self, "set_max_experience")
# warning-ignore:return_value_discarded
	Player2Stats.connect("level_changed", self, "set_level")
