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
	levelBox.set_text(str(Player1Stats.level))
	
func _ready():
	self.max_experience = Player1Stats.experience_required
	self.experienceProgress = Player1Stats.experience
	self.level = Player1Stats.level
	
# warning-ignore:return_value_discarded
	Player1Stats.connect("experience_changed", self, "set_experience")
# warning-ignore:return_value_discarded
	Player1Stats.connect("max_experience_changed", self, "set_max_experience")
# warning-ignore:return_value_discarded
	Player1Stats.connect("level_changed", self, "set_level")
