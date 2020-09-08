extends Control

var experienceProgress = 20 setget set_experience
var max_experience = 100 setget set_max_experience

onready var levelBox = $HBoxContainer/TextureRect/Label
onready var expBar = $ExpBarTexture

func set_experience(value):
	experienceProgress = value
	expBar.value = experienceProgress
	print(value)
	
func set_max_experience(value):
	max_experience = value
	expBar.max_value = max_experience
	
func _ready():
	self.max_experience = PlayerStats.experience_required
	self.experienceProgress = PlayerStats.experience
	
	PlayerStats.connect("experience_changed", self, "set_experience")
	PlayerStats.connect("max_experience_changed", self, "set_max_experience")
