extends Control

var origVIT = PlayerStats.vitality
var origEND = PlayerStats.endurance
var origDEF = PlayerStats.defense
var origSTR = PlayerStats.strength
var origDEX = PlayerStats.dexterity
var origSPD = PlayerStats.speed
var origMAG = PlayerStats.magic

onready var stats_remaining_label = $VBoxContainer/RichTextLabel
# onready var stats_bar = $VBoxContainer/HBoxContainer/ColorRect

onready var VIT_bar = $VBoxContainer/HBoxContainer/VBoxContainer/ColorRect1
onready var END_bar = $VBoxContainer/HBoxContainer/VBoxContainer/ColorRect2
onready var DEF_bar = $VBoxContainer/HBoxContainer/VBoxContainer/ColorRect3
onready var STR_bar = $VBoxContainer/HBoxContainer/VBoxContainer/ColorRect4
onready var DEX_bar = $VBoxContainer/HBoxContainer/VBoxContainer/ColorRect5
onready var SPD_bar = $VBoxContainer/HBoxContainer/VBoxContainer/ColorRect6
onready var MAG_bar = $VBoxContainer/HBoxContainer/VBoxContainer/ColorRect7

var stats_remaining : String
var stats_VIT : String
var description : String

func _ready():
	$Tween.interpolate_property(VIT_bar, "rect_size",
	Vector2(2, 2),
	Vector2(origVIT*2, 2),
	1.2,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	$Tween.interpolate_property(END_bar, "rect_size",
	Vector2(2, 2),
	Vector2(origEND*2, 2),
	1.2,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	$Tween.interpolate_property(DEF_bar, "rect_size",
	Vector2(2, 2),
	Vector2(origDEF*2, 2),
	1.2,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	$Tween.interpolate_property(STR_bar, "rect_size",
	Vector2(2, 2),
	Vector2(origSTR*2, 2),
	1.2,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	$Tween.interpolate_property(DEX_bar, "rect_size",
	Vector2(2, 2),
	Vector2(origDEX*2, 2),
	1.2,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	$Tween.interpolate_property(SPD_bar, "rect_size",
	Vector2(2, 2),
	Vector2(origSPD*2, 2),
	1.2,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	$Tween.interpolate_property(MAG_bar, "rect_size",
	Vector2(2, 2),
	Vector2(origMAG*2, 2),
	1.2,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	$Tween.start()
#	VIT_bar.rect_size.x = PlayerStats.vitality*2
#	END_bar.rect_size.x = PlayerStats.endurance*2
#	DEF_bar.rect_size.x = PlayerStats.defense*2
#	STR_bar.rect_size.x = PlayerStats.strength*2
#	DEX_bar.rect_size.x = PlayerStats.dexterity*2
#	SPD_bar.rect_size.x = PlayerStats.speed*2
#	MAG_bar.rect_size.x = PlayerStats.magic*2

func update_stats_remaining(value):
	stats_remaining = ""
	for i in value:
		stats_remaining += "|"
	stats_remaining_label.text = stats_remaining

func _on_ButtonVIT_focus_entered(_stat_color):
	pass
#	VIT_bar.rect_size.x = PlayerStats.vitality*2
#	END_bar.rect_size.x = PlayerStats.endurance*2
#	DEF_bar.rect_size.x = PlayerStats.defense*2
#	STR_bar.rect_size.x = PlayerStats.strength*2
#	DEX_bar.rect_size.x = PlayerStats.dexterity*2
#	SPD_bar.rect_size.x = PlayerStats.speed*2
#	MAG_bar.rect_size.x = PlayerStats.magic*2
	# stats_bar.rect_size.x = PlayerStats.vitality*2

func _on_ButtonEND_focus_entered(_stat_color):
	return
	# stats_bar.rect_size.x = PlayerStats.endurance*2

func _on_ButtonDEF_focus_entered(_stat_color):
	return
	# stats_bar.rect_size.x = PlayerStats.defense*2

func _on_ButtonSTR_focus_entered(_stat_color):
	return
	# stats_bar.rect_size.x = PlayerStats.strength*2

func _on_ButtonDEX_focus_entered(_stat_color):
	return
	# stats_bar.rect_size.x = PlayerStats.dexterity*2

func _on_ButtonSPD_focus_entered(_stat_color):
	return
	# stats_bar.rect_size.x = PlayerStats.speed*2

func _on_ButtonMAG_focus_entered(_stat_color):
	return
	# stats_bar.rect_size.x = PlayerStats.magic*2

func _on_Button_focus_entered(_stat_color):
	#stats_bar.modulate = Color(stat_color)
	description = ""
	stats_VIT = ""

func _on_ButtonVIT_pressed():
	VIT_bar.rect_size.x = PlayerStats.vitality*2

func _on_ButtonEND_pressed():
	END_bar.rect_size.x = PlayerStats.endurance*2
	
func _on_ButtonDEF_pressed():
	DEF_bar.rect_size.x = PlayerStats.defense*2

func _on_ButtonSTR_pressed():
	STR_bar.rect_size.x = PlayerStats.strength*2

func _on_ButtonDEX_pressed():
	DEX_bar.rect_size.x = PlayerStats.dexterity*2

func _on_ButtonSPD_pressed():
	SPD_bar.rect_size.x = PlayerStats.speed*2

func _on_ButtonMAG_pressed():
	MAG_bar.rect_size.x = PlayerStats.magic*2
