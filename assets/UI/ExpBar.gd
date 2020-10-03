extends Control

var experienceProgress setget set_experience
var max_experience setget set_max_experience
var level setget set_level

onready var levelBox = $HBoxContainer/TextureRect/Label
onready var expBar = $ExpBarTexture

func set_experience(value):
	experienceProgress = value
	expBar.value = experienceProgress
	
func set_max_experience(value):
	max_experience = value
	expBar.max_value = max_experience
	
func set_level(value):
	level = value
	levelBox.set_text(str(PlayerStats.level))
	
func _ready():
	self.max_experience = PlayerStats.experience_required
	self.experienceProgress = PlayerStats.experience
	self.level = PlayerStats.level
	
# warning-ignore:return_value_discarded
	PlayerStats.connect("experience_changed", self, "set_experience")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_experience_changed", self, "set_max_experience")
# warning-ignore:return_value_discarded
	PlayerStats.connect("level_changed", self, "set_level")
