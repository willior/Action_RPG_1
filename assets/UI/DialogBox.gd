extends Control

export(String, FILE, "*.json") var extenal_file = ''

var dialog_index = 0
var speakerName = ""
var next_icon_modulator

onready var label = $RichTextLabel

var dialog_script = [
	{
		'name': 'default',
		'text': 'default text',
	}
]

func file(file_path):
	# Reading a json file to use as a dialog.
	var file = File.new()
	var fileExists = file.file_exists(file_path)
	var dict = []
	if fileExists:
		file.open(file_path, File.READ)
		var content = file.get_as_text()
		dict = parse_json(content)
		file.close()
		return dict
	else:
		push_error("File " + file_path  + " doesn't exist. ")
	return dict
	
func parse_text(text):
	# This will parse the text and automatically format some of your available variables
	var end_text = text
	
	var c_variable
	for g in Global.custom_variables:
		if Global.custom_variables.has(g):
			c_variable = Global.custom_variables[g]
			# If it is a dictionary, get the label key
			if typeof(c_variable) == TYPE_DICTIONARY:
				if c_variable.has('label'):
					if '.value' in end_text:
						end_text = end_text.replace(g + '.value', c_variable['value'])
					end_text = end_text.replace('[' + g + ']', c_variable['label'])
			# Otherwise, just replace the value
			else:
				end_text = end_text.replace('[' + g + ']', c_variable)
	return end_text

func _ready():
	if extenal_file != '':
		dialog_script = file(extenal_file)
	event_handler(dialog_script[dialog_index])
	get_tree().paused = true
	Global.dialogOpen = true
	
func _input(_event):
	if Input.is_action_just_pressed("attack") || Input.is_action_just_pressed("examine") || Input.is_action_just_pressed("item"):
		load_dialog()
		
func update_name(event):
	# This function will search for the name key and try to parse it into the NameLabel node of the dialog
	if event.has('name'):
		$NameLabel.bbcode_text = parse_text(event['name'])
#		if '[name]' in event['name']:
#			$CloseUp.visible = true
#		else:
#			$CloseUp.visible = false
	else:
		$NameLabel.bbcode_text = ''
		# $CloseUp.visible = false

func update_text(text):
	label.bbcode_text = parse_text(text)
	label.set_visible_characters(0)
	return true
		
func load_dialog():
	if (label.get_visible_characters() > label.get_total_character_count() && dialog_index >= dialog_script.size()-1):
			# get_node("/root/World/YSort/Player").talking = false
			get_tree().paused = false
			get_node("/root/World/YSort/Player").noticeDisplay = false
			get_node("/root/World/YSort/Player").talkNoticeDisplay = false
			Global.dialogOpen = false
			queue_free()
	 # if the amount of visible characters is above the total amount of characters in the current index:
	elif label.get_visible_characters() > label.get_total_character_count():
		# if the number of dialog_indexes in the array is less than the total amount in the array
		if dialog_index < dialog_script.size()-1:
			# advancing the dialog_index
			dialog_index += 1
			# setting the dialog
			event_handler(dialog_script[dialog_index])
			# label.set_visible_characters(speakerName.length())
			$TimerText.start()
			$Sprite.hide()
			print('advancing to next dialog index')
	# if the amount of visible characters is less than the total amount of characters:
	else:
		# displays all the characters in the current dialog_index
		label.set_visible_characters(label.get_total_character_count())
		print('displaying all characters')

func event_handler(event):
	match event:
		{'text'}, {'name', 'text'}:
			update_name(event)
			update_text(event['text'])
		{'question', ..}:
			pass

func _on_TimerNext_timeout():
	if $Sprite.position.x == 266:
		next_icon_modulator = -1
	elif $Sprite.position.x == 263:
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
		print('text stopping')
