extends Control

var origVIT = PlayerStats.vitality
var origEND = PlayerStats.endurance
var origDEF = PlayerStats.defense
var origSTR = PlayerStats.strength
var origDEX = PlayerStats.dexterity
var origSPD = PlayerStats.speed
var origMAG = PlayerStats.magic

onready var stats_remaining_label = $VBoxContainer/RichTextLabel
onready var stats_bar = $VBoxContainer/HBoxContainer/ColorRect
var stats_remaining : String
var stats_VIT : String
var description : String

func _ready():
	stats_bar.rect_size.x = PlayerStats.vitality*2

func update_stats_remaining(value):
	stats_remaining = ""
	for i in value:
		stats_remaining += "|"
	stats_remaining_label.text = stats_remaining

func _on_ButtonVIT_focus_entered(_stat_color):
	stats_bar.rect_size.x = PlayerStats.vitality*2

func _on_ButtonEND_focus_entered(_stat_color):
	stats_bar.rect_size.x = PlayerStats.endurance*2

func _on_ButtonDEF_focus_entered(_stat_color):
	stats_bar.rect_size.x = PlayerStats.defense*2

func _on_ButtonSTR_focus_entered(_stat_color):
	stats_bar.rect_size.x = PlayerStats.strength*2

func _on_ButtonDEX_focus_entered(_stat_color):
	stats_bar.rect_size.x = PlayerStats.dexterity*2

func _on_ButtonSPD_focus_entered(_stat_color):
	stats_bar.rect_size.x = PlayerStats.speed*2

func _on_ButtonMAG_focus_entered(_stat_color):
	stats_bar.rect_size.x = PlayerStats.magic*2

func _on_Button_focus_entered(stat_color):
	stats_bar.modulate = Color(stat_color)
	description = ""
	stats_VIT = ""

func _on_ButtonVIT_pressed():
	stats_bar.rect_size.x = PlayerStats.vitality*2

func _on_ButtonEND_pressed():
	stats_bar.rect_size.x = PlayerStats.endurance*2
	
func _on_ButtonDEF_pressed():
	stats_bar.rect_size.x = PlayerStats.defense*2

func _on_ButtonSTR_pressed():
	stats_bar.rect_size.x = PlayerStats.strength*2

func _on_ButtonDEX_pressed():
	stats_bar.rect_size.x = PlayerStats.dexterity*2

func _on_ButtonSPD_pressed():
	stats_bar.rect_size.x = PlayerStats.speed*2

func _on_ButtonMAG_pressed():
	stats_bar.rect_size.x = PlayerStats.magic*2
