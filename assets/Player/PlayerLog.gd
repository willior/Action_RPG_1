extends Node

# Items
var heart_examined = false
var penny_examined = false

# Enemies
var bat_examined = false
var crow_examined = false
var tumbleweed_examined = false

# Home
var home_bed_examined = false
var home_window_examined = false
var home_chair_examined = false
var home_desk_examined = false
var home_lightswitch_examined = false
var home_fireplace_examined = false
var home_bookshelf_examined = false
var home_fridge_examined = false
var home_stove_examined = false

# NPCs
var skeleton_1_examined = false

func _ready():
	print('player log ready')
	print(home_chair_examined)
