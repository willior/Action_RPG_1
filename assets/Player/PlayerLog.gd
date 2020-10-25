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

#signals
signal home_window_complete()

# functions
func set_heart_examined(): pass
func set_penny_examined(): pass
func set_bat_examined(): pass
func set_crow_examined(): pass
func set_tumbleweed_examined(): pass
func set_home_window_examined():
	home_window_examined = true
	emit_signal("home_window_complete")
func set_home_lightswitch_examined(): pass
