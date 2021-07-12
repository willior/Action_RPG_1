extends HBoxContainer

var stats

func _ready():
	stats = get_parent().get_parent().get_parent().stats
	$Stats/LabelVIT.text = str(stats.vitality)
	$Stats/LabelEND.text = str(stats.endurance)
	$Stats/LabelDEF.text = str(stats.defense)
	$Stats/LabelSTR.text = str(stats.strength)
	$Stats/LabelDEX.text = str(stats.dexterity)
	$Stats/LabelSPD.text = str(stats.speed)
	$Stats/LabelMAG.text = str(stats.magic)

func _on_focus_entered():
	$AudioMenu.play()

func _on_ButtonVIT_pressed():
	stats.increment_vitality()
	SoundPlayer.play_sound("iloveit")
	$Stats/LabelVIT.text = str(stats.vitality)
	$Tween.interpolate_property($Stats/LabelVIT, "modulate",
	Color(0.25, 1, 1, 1),
	Color(1, 1, 1, 1),
	0.3,
	Tween.TRANS_QUAD, Tween.EASE_IN
	)
	$Tween.start()
	
func _on_ButtonEND_pressed():
	stats.increment_endurance()
	SoundPlayer.play_sound("great")
	$Stats/LabelEND.text = str(stats.endurance)
	$Tween.interpolate_property($Stats/LabelEND, "modulate",
	Color(0.25, 1, 1, 1),
	Color(1, 1, 1, 1),
	0.3,
	Tween.TRANS_QUAD, Tween.EASE_IN
	)
	$Tween.start()

func _on_ButtonDEF_pressed():
	stats.defense += 1
	SoundPlayer.play_sound("wow")
	$Stats/LabelDEF.text = str(stats.defense)
	$Tween.interpolate_property($Stats/LabelDEF, "modulate",
	Color(0.25, 1, 1, 1),
	Color(1, 1, 1, 1),
	0.3,
	Tween.TRANS_QUAD, Tween.EASE_IN
	)
	$Tween.start()

func _on_ButtonSTR_pressed():
	stats.strength += 1
	SoundPlayer.play_sound("awesome")
	$Stats/LabelSTR.text = str(stats.strength)
	$Tween.interpolate_property($Stats/LabelSTR, "modulate",
	Color(0.25, 1, 1, 1),
	Color(1, 1, 1, 1),
	0.3,
	Tween.TRANS_QUAD, Tween.EASE_IN
	)
	$Tween.start()

func _on_ButtonDEX_pressed():
	stats.dexterity += 1
	SoundPlayer.play_sound("whistle")
	$Stats/LabelDEX.text = str(stats.dexterity)
	$Tween.interpolate_property($Stats/LabelDEX, "modulate",
	Color(0.25, 1, 1, 1),
	Color(1, 1, 1, 1),
	0.3,
	Tween.TRANS_QUAD, Tween.EASE_IN
	)
	$Tween.start()

func _on_ButtonSPD_pressed():
	stats.speed += 1
	SoundPlayer.play_sound("nice")
	$Stats/LabelSPD.text = str(stats.speed)
	$Tween.interpolate_property($Stats/LabelSPD, "modulate",
	Color(0.25, 1, 1, 1),
	Color(1, 1, 1, 1),
	0.3,
	Tween.TRANS_QUAD, Tween.EASE_IN
	)
	$Tween.start()

func _on_ButtonMAG_pressed():
	stats.magic += 1
	SoundPlayer.play_sound("cool")
	$Stats/LabelMAG.text = str(stats.magic)
	$Tween.interpolate_property($Stats/LabelMAG, "modulate",
	Color(0.25, 1, 1, 1),
	Color(1, 1, 1, 1),
	0.3,
	Tween.TRANS_QUAD, Tween.EASE_IN
	)
	$Tween.start()
