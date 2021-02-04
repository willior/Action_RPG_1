extends Control

const BUTTON = preload("Dialog/Dialog_Button.tscn")
# const LEVELUPCONTAINER = preload("Dialog/LevelUp_Container.tscn")
onready var label = $Text/RichTextLabel

var default_stats_remaining = 2
var stats_remaining = default_stats_remaining
var VIT_to_add = 0
var END_to_add = 0
var DEF_to_add = 0
var STR_to_add = 0
var DEX_to_add = 0
var SPD_to_add = 0

var dialog_index = 0
var speaker = "Nobody"
var next_icon_modulator = 1
var finished = false
var level_flag = false
var waiting_for_answer = false
var waiting_for_level = false
var waiting_for_input = false
var dialog_object_path
var dialog_script = [
				{
					'level_up': '2',
					'text': "LEVEL UP!!",
				},
#				{
#					'question': "Are you sure about that?",
#					'options': [
#						{ 'label': 'Well... no...', 'value': '0'},
#						{ 'label': 'Yup.', 'value': 'r'}
#					],
#					'checkpoint': '-2',
#				},
#				{
#					'text': "You levelled successfully!",
#					'action': 'apply_level'
#				},
				{
					'action': 'end_dialog'
				}
			]

func _process(_delta):
	if waiting_for_answer:
		$OptionsRect.visible = finished
	else:
		$OptionsRect.visible = false

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
	event_handler(dialog_script[dialog_index])
	get_tree().paused = true
	Global.dialogOpen = true
	$AudioLevel.play()
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		if !$TimerDelaySelect.is_stopped() || !waiting_for_input:
			print('input while delay timer is not stopped')
			get_tree().set_input_as_handled()
			return
		elif waiting_for_input:
			print('waiting_for_input: stats remaining = ', stats_remaining)
			if stats_remaining == 0:
				waiting_for_input = false
				return
			$AudioSelect.play()
			return
		else:
			print('ending level screen')
			get_tree().set_input_as_handled()
			load_dialog()
		
func update_name(event):
	# search for the name key and parse it into the NameLabel
	if event.has('name'):
		$Text/NameLabel.bbcode_text = parse_text(event['name'])
#		if '[name]' in event['name']:
#			$CloseUp.visible = true
#		else:
#			$CloseUp.visible = false
	else:
		$Text/NameLabel.bbcode_text = ''
		# $CloseUp.visible = false

func update_text(text):
	label.bbcode_text = parse_text(text)
	label.set_visible_characters(0)
	return true
		
func load_dialog():
	if (label.get_visible_characters() > label.get_total_character_count() && dialog_index >= dialog_script.size()-1):
		end_dialog()
	 # if the amount of visible characters is above the total amount of characters in the current index:
	elif label.get_visible_characters() > label.get_total_character_count():
		# if the number of dialog_indexes in the array is less than the total amount in the array
		if dialog_index < dialog_script.size()-1:
			dialog_index += 1
			# setting the dialog
			event_handler(dialog_script[dialog_index])
			$TimerText.start()
			# $Text/Sprite.hide()
	# if the amount of visible characters is less than the total amount of characters:
	else:
		# displays all the characters in the current dialog_index
		label.set_visible_characters(label.get_total_character_count())
		finished = true
		
func end_dialog():
	get_tree().paused = false
	Global.dialogOpen = false
	queue_free()
	Global.reset_input_after_dialog()
	

func event_handler(event):
	match event:
		{'text'}, {'name', 'text'}:
			finished = false
			update_name(event)
			update_text(event['text'])
		{'text', 'skip'}, {'name', 'text', 'skip'}:
			finished = false
			advance_dialog(int(event['skip']))
			update_name(event)
			update_text(event['text'])
		{'question', ..}:
			finished = false
			waiting_for_answer = true
			update_name(event)
			update_text(event['question'])
			for o in event['options']:
				var button = BUTTON.instance()
				# button.get_node("Label").bbcode_text = o['label']
				button.text = o['label']
				if event.has('variable'):
					button.connect("pressed", self, "_on_option_selected", [button, event['variable'], o])
					# connects the button's "pressed" signal to the _on_option_selected function
					# 3 arguments:
					# 1. reference variable to the button itself  // button
					# 2. the index named 'variable' of the event being handled // event['variable']
					# 3. the 'options' array that follows the 'question' // o
				else:
					# Checking for checkpoints
					if o['value'] == '0':
						button.connect("pressed", self, "change_position", [button, int(event['checkpoint'])])
						button.connect("pressed", self, "reset_level_stats")
					else:
						button.connect("pressed", self, "change_position", [button, 0])
				
				$OptionsRect/Options.add_child(button)
		
		{'level_up', 'text'}:
			finished = false
			waiting_for_answer = true
			waiting_for_level = true
			level_flag = true
			update_text(event['text'])
			# stats_remaining = default_stats_remaining
#			var levelUpButtons = LEVELUPCONTAINER.instance()
#			$OptionsRect.add_child(levelUpButtons)
# warning-ignore:return_value_discarded
			$OptionsRect/LevelUp_Rect/LevelUp_Container/Options/ButtonVIT.connect("pressed", self, "_on_level_selected", ["VIT"])
# warning-ignore:return_value_discarded
			$OptionsRect/LevelUp_Rect/LevelUp_Container/Options/ButtonEND.connect("pressed", self, "_on_level_selected", ["END"])
# warning-ignore:return_value_discarded
			$OptionsRect/LevelUp_Rect/LevelUp_Container/Options/ButtonDEF.connect("pressed", self, "_on_level_selected", ["DEF"])
# warning-ignore:return_value_discarded
			$OptionsRect/LevelUp_Rect/LevelUp_Container/Options2/ButtonSTR.connect("pressed", self, "_on_level_selected", ["STR"])
# warning-ignore:return_value_discarded
			$OptionsRect/LevelUp_Rect/LevelUp_Container/Options2/ButtonDEX.connect("pressed", self, "_on_level_selected", ["DEX"])
# warning-ignore:return_value_discarded
			$OptionsRect/LevelUp_Rect/LevelUp_Container/Options2/ButtonSPD.connect("pressed", self, "_on_level_selected", ["SPD"])
			
			
		{'action', ..}:
			if event['action'] == 'take_item':
				advance_dialog(int(event['skip']))
				update_name(event)
				update_text(event['text'])
				get_node(dialog_object_path).acquire_item()
				
			if event['action'] == 'apply_level':
				#update_text(event['text'])
				apply_level_stats()
				
			if event['action'] == 'end_dialog':
				get_node("/root/World/GUI/TweenGreyscale").fade_out_greyscale()
				#SoundPlayer.stop_music()
				$Music.stop()
				$TimerDelaySelect.start()
				yield($TimerDelaySelect, "timeout")
				end_dialog()

func reset_options():
	for option in $OptionsRect/Options.get_children():
		option.queue_free()

func change_position(_i, checkpoint):
	waiting_for_answer = false
	dialog_index += checkpoint
	# reset_level_stats()
	reset_options()
	load_dialog()

func _on_option_selected(option, variable, value):
	Global.custom_variables[variable] = value
	waiting_for_answer = false
	advance_dialog(int(value['skip']))
	reset_options()
	load_dialog()
	print('[!] Option selected: ', option.text, ' \\//\\ value = ' , value)
	
func _on_level_selected(value):
	stats_remaining -= 1
	match value:
		"VIT":
			#print('applying V')
			VIT_to_add += 1
		"END":
			#print('applying E')
			END_to_add += 1
		"DEF":
			#print('applying D')
			DEF_to_add += 1
		"STR":
			#print('applying ST')
			STR_to_add += 1
		"DEX":
			#print('applying DX')
			DEX_to_add += 1
		"SPD":
			#print('applying SP')
			SPD_to_add += 1
	
	if stats_remaining == 0:
		print(value, ' incremented... 0 stats remaining. stats to add:')
		waiting_for_answer = false
		waiting_for_level = false
		waiting_for_input = false
		$OptionsRect/LevelUp_Rect.queue_free()
		print(VIT_to_add, ' VIT')
		print(END_to_add, ' END')
		print(DEF_to_add, ' DEF')
		print(STR_to_add, ' STR')
		print(DEX_to_add, ' DEX')
		print(SPD_to_add, ' SPD')
		load_dialog()
		
	else:
		print(value, ' incremented... ', stats_remaining, ' stats remaining.')
		
func reset_level_stats():
	print('resetting level stats.')
	stats_remaining = default_stats_remaining
	VIT_to_add = 0
	END_to_add = 0
	DEF_to_add = 0
	STR_to_add = 0
	DEX_to_add = 0
	SPD_to_add = 0

func apply_level_stats():
	print('applying stats: ')
	if VIT_to_add > 0:
		# PlayerStats.vitality += VIT_to_add
		print(VIT_to_add, ' VIT')
	if END_to_add > 0:
		# PlayerStats.endurance += END_to_add
		print(END_to_add, ' END')
	if DEF_to_add > 0:
		# PlayerStats.defense += DEF_to_add
		print(DEF_to_add, ' DEF')
	if STR_to_add > 0:
		# PlayerStats.strength += STR_to_add
		print(STR_to_add, ' STR')
	if DEX_to_add > 0:
		# PlayerStats.dexterity += DEX_to_add
		print(DEX_to_add, ' DEX')
	if SPD_to_add > 0:
		# PlayerStats.speed += SPD_to_add
		print(SPD_to_add, ' SPD')

func advance_dialog(skip_index):
	dialog_index += skip_index

func _on_TimerNext_timeout():
	pass
#	if $Text/Sprite.position.x == 268:
#		next_icon_modulator = -1
#	elif $Text/Sprite.position.x == 265:
#		next_icon_modulator = 1
#	$Text/Sprite.position.x += next_icon_modulator

func _on_TimerText_timeout():
	if label.get_visible_characters() <= label.get_total_character_count():
		$AudioStreamPlayer.play()
		label.set_visible_characters(label.get_visible_characters()+1)
	else:
		$AudioStreamPlayer.stop()
		$TimerText.stop()
		# $Text/Sprite.show()
		finished = true
		
		if waiting_for_answer:
			$TimerDelaySelect.start()
			yield($TimerDelaySelect, "timeout")
			if level_flag:
				$Music.play()
				get_child(1).get_child(1).get_child(0).get_child(0).get_child(0).grab_focus()
				print('level flag')
				level_flag = false
				waiting_for_input = true
				
			else:
				print('not level flag')
				get_child(1).get_child(0).get_child(0).grab_focus()
				waiting_for_input = true
		
		#SoundPlayer.play_music("level_up")
