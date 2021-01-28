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
#			levelNotice.statColor = Color(0.666, 0.392549, 0)
#		LEVELDEFENSE:
#			stats.defense += 1
#			levelNotice.statDisplay = "HARDINESS"
#			levelNotice.statColor = Color(0.2, 0.2, 1)
#		LEVELSTAMINA:
#			stats.endurance += 1
#			# stats.max_stamina += 15
#			levelNotice.statDisplay = "LUNG CAPACITY"
#			levelNotice.statColor = Color(0.372549, 1, 0.415686)
#		LEVELSTRENGTH:
#			stats.strength += 1
#			levelNotice.statDisplay = "VIOLENT NATURE"
#			levelNotice.statColor = Color(1, 0.12, 0)
#		LEVELDEXTERITY:
#			stats.dexterity += 1
#			levelNotice.statDisplay = "PATIENCE"
#			levelNotice.statColor = Color(0.324902, 0.622549, 0.705686)
#		LEVELSPEED:
#			stats.iframes += 0.1
#			stats.speed += 1
#			levelNotice.statDisplay = "SWIFTNESS"
#			levelNotice.statColor = Color(1, 1, 0.665686)
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
