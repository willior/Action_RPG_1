extends HBoxContainer

var VIT_to_add = 0
var END_to_add = 0
var DEF_to_add = 0
var STR_to_add = 0
var DEX_to_add = 0
var SPD_to_add = 0

func _on_focus_entered():
	$AudioMenu.play()

func _on_ButtonVIT_pressed():
	# VIT_to_add += 1
	PlayerStats.vitality += 1
	SoundPlayer.play_sound("iloveit")
	
func _on_ButtonEND_pressed():
	# END_to_add += 1
	PlayerStats.endurance += 1
	SoundPlayer.play_sound("great")

func _on_ButtonDEF_pressed():
	# DEF_to_add += 1
	PlayerStats.defense += 1
	SoundPlayer.play_sound("wow")

func _on_ButtonSTR_pressed():
	# STR_to_add += 1
	PlayerStats.strength += 1
	SoundPlayer.play_sound("awesome")

func _on_ButtonDEX_pressed():
	# DEX_to_add += 1
	PlayerStats.dexterity += 1
	SoundPlayer.play_sound("whistle")

func _on_ButtonSPD_pressed():
	# SPD_to_add += 1
	PlayerStats.speed += 1
	SoundPlayer.play_sound("nice")
