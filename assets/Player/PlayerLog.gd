extends Node

var examined_list = []
var chapter_number = 0
var home = {
	desk_on = false,
	lightswitch_checked = false,
	lightswitch_bedroom_on = false,
	lightswitch_main_on = false,
	fridge_open = false,
	sink_on = false,
	stove_on = false,
	metal_pot_collected = false
}

func save():
	var save_dict = {
		"chapter_number": chapter_number,
		"examined_list": examined_list,
		"home": home
	}
	return save_dict

func reset_player_log():
	examined_list = []
	chapter_number = 0
	home = {
		desk_on = false,
		lightswitch_checked = false,
		lightswitch_bedroom_on = false,
		lightswitch_main_on = false,
		fridge_open = false,
		sink_on = false,
		stove_on = false,
		metal_pot_collected = false
	}

# when examining an object for the final time, the object sets the
# global examined variable to true as well as runs a function that
# tells the PlayerLog which signal to emit. this signal then sets
# the object's local examined variable to true.
func set_examined(name):
	examined_list.append(name)
	for p in get_tree().get_nodes_in_group("Players"):
		p.reset_interaction()
	
func set_examined_and_signal(name, value=true):
	examined_list.append(name)
	emit_signal(str(name.replace(" ", "_"))+"_complete", value)
	for p in get_tree().get_nodes_in_group("Players"):
		p.reset_interaction()

# warning-ignore:unused_signal
signal Rock_complete()
# warning-ignore:unused_signal
signal Clay_complete()
# warning-ignore:unused_signal
signal Water_complete()
# warning-ignore:unused_signal
signal Salt_complete()
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

# the PlayerLog is now responsible for advancing the dialog index in the
# function set_dialog_index(name, value) where 'name' is the name of the
# object and 'value' is the index to which it advances. this function
# emits a signal which the object listens for. when that occurs, the
# object's advance_dialog_index(value) function is called, with 'value'
# corresponding to the dialog index to which the object should advance.
func set_dialog_index(name, value):
	emit_signal(str(name)+"_advance", value)
