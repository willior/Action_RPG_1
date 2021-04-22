extends HBoxContainer

func _ready():
	$Stats/LabelVIT.text = str(PlayerStats.vitality)
	$Stats/LabelEND.text = str(PlayerStats.endurance)
	$Stats/LabelDEF.text = str(PlayerStats.defense)
	$Stats/LabelSTR.text = str(PlayerStats.strength)
	$Stats/LabelDEX.text = str(PlayerStats.dexterity)
	$Stats/LabelSPD.text = str(PlayerStats.speed)

func _on_focus_entered():
	$AudioMenu.play()

func _on_ButtonVIT_pressed():
	PlayerStats.vitality += 1
	SoundPlayer.play_sound("iloveit")
	$Stats/LabelVIT.text = str(PlayerStats.vitality)
	$Tween.interpolate_property($Stats/LabelVIT, "modulate",
	Color(0.25, 1, 1, 1),
	Color(1, 1, 1, 1),
	0.3,
	Tween.TRANS_QUAD, Tween.EASE_IN
	)
	$Tween.start()
	
func _on_ButtonEND_pressed():
	PlayerStats.endurance += 1
	SoundPlayer.play_sound("great")
	$Stats/LabelEND.text = str(PlayerStats.endurance)
	$Tween.interpolate_property($Stats/LabelEND, "modulate",
	Color(0.25, 1, 1, 1),
	Color(1, 1, 1, 1),
	0.3,
	Tween.TRANS_QUAD, Tween.EASE_IN
	)
	$Tween.start()

func _on_ButtonDEF_pressed():
	PlayerStats.defense += 1
	SoundPlayer.play_sound("wow")
	$Stats/LabelDEF.text = str(PlayerStats.defense)
	$Tween.interpolate_property($Stats/LabelDEF, "modulate",
	Color(0.25, 1, 1, 1),
	Color(1, 1, 1, 1),
	0.3,
	Tween.TRANS_QUAD, Tween.EASE_IN
	)
	$Tween.start()

func _on_ButtonSTR_pressed():
	PlayerStats.strength += 1
	SoundPlayer.play_sound("awesome")
	$Stats/LabelSTR.text = str(PlayerStats.strength)
	$Tween.interpolate_property($Stats/LabelSTR, "modulate",
	Color(0.25, 1, 1, 1),
	Color(1, 1, 1, 1),
	0.3,
	Tween.TRANS_QUAD, Tween.EASE_IN
	)
	$Tween.start()

func _on_ButtonDEX_pressed():
	PlayerStats.dexterity += 1
	SoundPlayer.play_sound("whistle")
	$Stats/LabelDEX.text = str(PlayerStats.dexterity)
	$Tween.interpolate_property($Stats/LabelDEX, "modulate",
	Color(0.25, 1, 1, 1),
	Color(1, 1, 1, 1),
	0.3,
	Tween.TRANS_QUAD, Tween.EASE_IN
	)
	$Tween.start()

func _on_ButtonSPD_pressed():
	PlayerStats.speed += 1
	SoundPlayer.play_sound("nice")
	$Stats/LabelSPD.text = str(PlayerStats.speed)
	$Tween.interpolate_property($Stats/LabelSPD, "modulate",
	Color(0.25, 1, 1, 1),
	Color(1, 1, 1, 1),
	0.3,
	Tween.TRANS_QUAD, Tween.EASE_IN
	)
	$Tween.start()
