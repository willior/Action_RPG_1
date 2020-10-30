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
var home_sink_examined = false

var home_desk_on = false
var home_lightswitch_bedroom_on = false
var home_lightswitch_main_on = false
var home_fridge_open = false
var home_sink_on = false
var home_music_on = false

var metal_pot_collected = false

# NPCs
var skeleton_1_examined = false

# warning-ignore:unused_signal
signal heart_complete()
# warning-ignore:unused_signal
signal penny_complete()
# warning-ignore:unused_signal
signal bat_complete()
# warning-ignore:unused_signal
signal crow_complete()
# warning-ignore:unused_signal
signal tumbleweed_complete()
# warning-ignore:unused_signal
signal home_lightswitch_advance(value)
# warning-ignore:unused_signal
signal home_lightswitch_complete()
# warning-ignore:unused_signal
signal home_window_advance(value)
# warning-ignore:unused_signal
signal home_window_complete()
# warning-ignore:unused_signal
signal home_sink_complete()

# when examining an object for the final time, the object sets the
# global examined variable to true as well as runs a function that
# tells the PlayerLog which signal to emit. this signal then sets
# the object's local examined variable to true.
func set_examined(name, value):
	print('examined ' + name)
	emit_signal(str(name)+"_complete", value)

# the PlayerLog is now responsible for advancing the dialog index in the
# function set_dialog_index(name, value) where 'name' is the name of the
# object and 'value' is the index to which it advances. this function
# emits a signal which the object listens for. when that occurs, the
# object's advance_dialog_index(value) function is called, with 'value'
# corresponding to the dialog index to which the object should advance.
func set_dialog_index(name, value):
	emit_signal(str(name)+"_advance", value)
