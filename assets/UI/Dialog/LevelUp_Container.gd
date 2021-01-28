extends HBoxContainer

var stats_remaining = 2

var VIT_to_add = 0
var END_to_add = 0
var DEF_to_add = 0
var STR_to_add = 0
var DEX_to_add = 0
var SPD_to_add = 0

var stat_key

var stats_to_add = {
		'VIT': 0,
		'END': 0,
		'DEF': 0,
		'STR': 0,
		'DEX': 0,
		'SPD': 0,
	}

func _on_focus_entered():
	$AudioMenu.play()

func _on_ButtonVIT_pressed():
	VIT_to_add += 1
	SoundPlayer.play_sound("iloveit")
	button_pressed()
	
func _on_ButtonEND_pressed():
	END_to_add += 1
	SoundPlayer.play_sound("great")
	button_pressed()

func _on_ButtonDEF_pressed():
	DEF_to_add += 1
	SoundPlayer.play_sound("wow")
	button_pressed()

func _on_ButtonSTR_pressed():
	STR_to_add += 1
	SoundPlayer.play_sound("awesome")
	button_pressed()

func _on_ButtonDEX_pressed():
	DEX_to_add += 1
	SoundPlayer.play_sound("whistle")
	button_pressed()

func _on_ButtonSPD_pressed():
	SPD_to_add += 1
	SoundPlayer.play_sound("nice")
	button_pressed()
	
func button_pressed():
	get_tree().set_input_as_handled()
	print('button pressed')
