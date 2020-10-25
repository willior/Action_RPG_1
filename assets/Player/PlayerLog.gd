extends Node

# when examining an object for the final time, runs a function in the
# PlayerLog corresponding to the examined object that both sets the global
# examined variable to true, and emits a signal that all objects of the same
# type listen for. this signal runs a function local to the objects that sets
# the local examined variables to true.

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
signal heart_complete()
signal penny_complete()
signal bat_complete()
signal crow_complete()
signal tumbleweed_complete()

signal home_lightswitch_complete()
signal home_window_complete()

func set_examined(name):
	print('examined ' + name)
	emit_signal(str(name)+"_complete")
