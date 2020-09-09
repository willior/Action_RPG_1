extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty

func set_hearts(value):
	hearts = value
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * 15 # sinze the width of each heart is 15px, changing the size of the full UI element by a factor of 15 effectively brings individual hearts into or out of view
	
func set_max_hearts(value):
	max_hearts = value
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * 15
	
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts") # connecting to the "health_changed" signal to the UI, connecting the value passed to the "set_hearts" function
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
