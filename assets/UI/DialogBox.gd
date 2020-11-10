extends Control

var dialog = [
	'Hello.',
	'This is the second line of dialog. Number two.',
	'This, here, is the third line of dialog. ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789XXXYYYZZZAAABBBCCCDDDASDFJKL;QWERTY###################'
]

var dialog_index = 0
var finished = false
var next_icon_modulator

func _ready():
	load_dialog()
	
func _input(_event):
	if Input.is_action_just_pressed("attack") || Input.is_action_just_pressed("examine") || Input.is_action_just_pressed("item"):
		load_dialog()
	
func load_dialog():
	if dialog_index < dialog.size():
		$RichTextLabel.bbcode_text = dialog[dialog_index]
	dialog_index += 1

func _on_Timer_timeout():
	if $Sprite.position.x == 283:
		next_icon_modulator = -1
	elif $Sprite.position.x == 280:
		next_icon_modulator = 1
	$Sprite.position.x += next_icon_modulator
