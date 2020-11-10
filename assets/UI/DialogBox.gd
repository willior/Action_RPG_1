extends Control

var dialog = [
	'Hello.',
	'This is the second line of dialog. Number two.',
	'1234567890 12345678901234567890123456789012345678901234567890123456789 012345678901234567890'
]

var dialog_index = 0
var speakerName = "DefaultName"
var next_icon_modulator

onready var label = $RichTextLabel

func _ready():
	for x in range(0, dialog.size()):
		dialog[x] = str(speakerName + ": " + dialog[x])
	label.set_bbcode(dialog[dialog_index])
	label.set_visible_characters(speakerName.length())
	label.set_process_input(true)
	
func _input(_event):
	if Input.is_action_just_pressed("attack") || Input.is_action_just_pressed("examine") || Input.is_action_just_pressed("item"):
		load_dialog()
	
func load_dialog():
	# if at the end of the dialog
		if (label.get_visible_characters() > label.get_total_character_count() && dialog_index >= dialog.size()-1):
			# get_node("/root/World/YSort/Player").talking = false
			get_tree().paused = false
			get_node("/root/World/YSort/Player").noticeDisplay = false
			get_node("/root/World/YSort/Player").talkNoticeDisplay = false
			Global.dialogOpen = false
			queue_free()
		# if the amount of visible characters is above the total amount of characters in the current index:
		elif label.get_visible_characters() > label.get_total_character_count():
			# if the number of dialog_indexes in the array is less than the total amount in the array
			if dialog_index < dialog.size()-1:
				# advancing the dialog_index
				dialog_index += 1
				# setting the dialog
				label.set_bbcode(dialog[dialog_index])
				label.set_visible_characters(speakerName.length() + 2)
				$TimerText.start()
				$Sprite.hide()
		# if the amount of visible characters is less than the total amount of characters:
		else:
			# displays all the characters in the current dialog_index
			label.set_visible_characters(label.get_total_character_count())

func _on_TimerNext_timeout():
	if $Sprite.position.x == 283:
		next_icon_modulator = -1
	elif $Sprite.position.x == 280:
		next_icon_modulator = 1
	$Sprite.position.x += next_icon_modulator

func _on_TimerText_timeout():
	if label.get_visible_characters() <= label.get_total_character_count():
		$AudioStreamPlayer.play()
		label.set_visible_characters(label.get_visible_characters()+1)
	else:
		$AudioStreamPlayer.stop()
		$TimerText.stop()
		$Sprite.show()
