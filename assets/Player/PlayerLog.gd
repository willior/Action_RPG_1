extends Node

var chapter_number = 0

var examined_list = []

var metal_pot_use_index = 0
var home_desk_on = false
var home_lightswitch_checked = false
var home_lightswitch_bedroom_on = false
var home_lightswitch_main_on = false
var home_fridge_open = false
var home_sink_on = false
var home_stove_on = false
var home_music_on = false

var metal_pot_collected = false

# NPCs
var skeleton_1_examined = false

# warning-ignore:unused_signal
signal heart_complete()
# warning-ignore:unused_signal
signal penny_complete()
# warning-ignore:unused_signal
signal Bat_complete()
# warning-ignore:unused_signal
signal Crow_complete()
# warning-ignore:unused_signal
signal Wolf_complete()
# warning-ignore:unused_signal
signal Tumbleweed_complete()
# warning-ignore:unused_signal
signal PunchingMoon_complete()
# warning-ignore:unused_signal
signal The_Moon_complete()

# warning-ignore:unused_signal
signal home_lightswitch_advance(value)
# warning-ignore:unused_signal
signal home_lightswitch_complete()
# warning-ignore:unused_signal
signal home_window_advance(value)
# warning-ignore:unused_signal
signal home_window_complete()

func save():
	var save_dict = {
		"chapter_number": chapter_number,
		"examined_list": examined_list
	}
	return save_dict

func reset_player_log():
	examined_list = []
	chapter_number = 0
	metal_pot_use_index = 0

# when examining an object for the final time, the object sets the
# global examined variable to true as well as runs a function that
# tells the PlayerLog which signal to emit. this signal then sets
# the object's local examined variable to true.
func set_examined(name):
	examined_list.append(name)
	
func set_examined_and_signal(name, value=true):
	examined_list.append(name)
	emit_signal(str(name.replace(" ", "_"))+"_complete", value)

# the PlayerLog is now responsible for advancing the dialog index in the
# function set_dialog_index(name, value) where 'name' is the name of the
# object and 'value' is the index to which it advances. this function
# emits a signal which the object listens for. when that occurs, the
# object's advance_dialog_index(value) function is called, with 'value'
# corresponding to the dialog index to which the object should advance.
func set_dialog_index(name, value):
	emit_signal(str(name)+"_advance", value)
