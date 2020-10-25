extends Node

# Items
var heart_examined = false setget set_heart_examined
var penny_examined = false setget set_penny_examined

# Enemies
var bat_examined = false setget set_bat_examined
var crow_examined = false setget set_crow_examined
var tumbleweed_examined = false setget set_tumbleweed_examined

# Home
var home_bed_examined = false
var home_window_examined = false setget set_home_window_examined
var home_chair_examined = false
var home_desk_examined = false
var home_lightswitch_examined = false setget set_home_lightswitch_examined
var home_fireplace_examined = false
var home_bookshelf_examined = false
var home_fridge_examined = false
var home_stove_examined = false

# NPCs
var skeleton_1_examined = false

#signals
signal home_window_complete(value)

# functions
func set_heart_examined(value): pass
func set_penny_examined(value): pass
func set_bat_examined(value): pass
func set_crow_examined(value): pass
func set_tumbleweed_examined(value): pass
func set_home_window_examined(value):
	home_window_examined = value
	emit_signal("home_window_complete", value)
func set_home_lightswitch_examined(value): pass
