extends Control
onready var label = $LevelText/RichTextLabel
onready var stats_remaining_label = $StatPreview/RichTextLabel
var default_stats_remaining = 2
var stats_remaining = default_stats_remaining
var VIT_to_add = 0
var END_to_add = 0
var DEF_to_add = 0
var STR_to_add = 0
var DEX_to_add = 0
var SPD_to_add = 0
var MAG_to_add = 0
var dialog_index = 0
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
	{
		'action': 'end_dialog'
	}
]

func parse_text(text):
	var end_text = text
	var c_variable
	for g in Global.custom_variables:
		if Global.custom_variables.has(g):
			c_variable = Global.custom_variables[g]
			if typeof(c_variable) == TYPE_DICTIONARY:
				if c_variable.has('label'):
					if '.value' in end_text:
						end_text = end_text.replace(g + '.value', c_variable['value'])
					end_text = end_text.replace('[' + g + ']', c_variable['label'])
			else:
				end_text = end_text.replace('[' + g + ']', c_variable)
	return end_text

func _ready():
	event_handler(dialog_script[dialog_index])
	get_tree().paused = true
	Global.dialogOpen = true
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		if !$TimerDelaySelect.is_stopped() || !waiting_for_input:
			get_tree().set_input_as_handled()
			return
		elif waiting_for_input:
			print('stats remaining = ', stats_remaining)
			if stats_remaining == 0:
				waiting_for_input = false
				return
			$AudioSelect.play()
			return
		else:
			print('ending level screen')
			get_tree().set_input_as_handled()
			load_dialog()

func update_text(text):
	label.bbcode_text = parse_text(text)
	label.set_visible_characters(0)
	return true
		
func load_dialog():
	if (label.get_visible_characters() > label.get_total_character_count() && dialog_index >= dialog_script.size()-1):
		print('hi this should not be here')
		end_dialog()
	elif label.get_visible_characters() > label.get_total_character_count():
		if dialog_index < dialog_script.size()-1:
			dialog_index += 1
			event_handler(dialog_script[dialog_index])
			$TimerText.start()
	else:
		print('hi this should not be here')
		label.set_visible_characters(label.get_total_character_count())
		finished = true

func event_handler(event):
	match event:
		{'level_up', 'text'}:
			$LevelText/AnimationPlayer.play("On")
			$Tween.interpolate_property($OptionsRect, "modulate",
			Color(1, 1, 1, 0),
			Color(1, 1, 1, 1),
			1.2,
			Tween.TRANS_QUINT, Tween.EASE_IN_OUT
			)
			$Tween.interpolate_property($LevelDescription, "modulate",
			Color(1, 1, 1, 0),
			Color(1, 1, 1, 1),
			1.2,
			Tween.TRANS_QUINT, Tween.EASE_IN_OUT
			)
			$Tween.interpolate_property($StatPreview, "modulate",
			Color(1, 1, 1, 0),
			Color(1, 1, 1, 1),
			1.2,
			Tween.TRANS_QUINT, Tween.EASE_IN_OUT
			)
			$Tween.interpolate_property($PanelTop, "rect_position",
			Vector2(0, -45),
			Vector2(0, 0),
			1.2,
			Tween.TRANS_QUINT, Tween.EASE_IN_OUT
			)
			$Tween.interpolate_property($PanelBottom, "rect_position",
			Vector2(0, 180),
			Vector2(0, 135),
			1.2,
			Tween.TRANS_QUINT, Tween.EASE_IN_OUT
			)
			$Tween.start()
			finished = false
			waiting_for_answer = true
			waiting_for_level = true
			level_flag = true
			update_text(event['text'])
# warning-ignore:return_value_discarded
			$OptionsRect/LevelUp_Rect/LevelUp_Container/Options/ButtonVIT.connect("pressed", self, "_on_level_selected", ["VIT"])
# warning-ignore:return_value_discarded
			$OptionsRect/LevelUp_Rect/LevelUp_Container/Options/ButtonEND.connect("pressed", self, "_on_level_selected", ["END"])
# warning-ignore:return_value_discarded
			$OptionsRect/LevelUp_Rect/LevelUp_Container/Options/ButtonDEF.connect("pressed", self, "_on_level_selected", ["DEF"])
# warning-ignore:return_value_discarded
			$OptionsRect/LevelUp_Rect/LevelUp_Container/Options/ButtonSTR.connect("pressed", self, "_on_level_selected", ["STR"])
# warning-ignore:return_value_discarded
			$OptionsRect/LevelUp_Rect/LevelUp_Container/Options/ButtonDEX.connect("pressed", self, "_on_level_selected", ["DEX"])
# warning-ignore:return_value_discarded
			$OptionsRect/LevelUp_Rect/LevelUp_Container/Options/ButtonSPD.connect("pressed", self, "_on_level_selected", ["SPD"])
# warning-ignore:return_value_discarded
			$OptionsRect/LevelUp_Rect/LevelUp_Container/Options/ButtonMAG.connect("pressed", self, "_on_level_selected", ["MAG"])
			
		{'action', ..}:
			if event['action'] == 'apply_level':
				apply_level_stats()
			if event['action'] == 'end_dialog':
				$Tween.interpolate_property($PanelTop, "rect_position",
				Vector2(0, 0),
				Vector2(0, -45),
				0.6,
				Tween.TRANS_QUINT, Tween.EASE_IN_OUT
				)
				$Tween.interpolate_property($PanelBottom, "rect_position",
				Vector2(0, 135),
				Vector2(0, 180),
				0.6,
				Tween.TRANS_QUINT, Tween.EASE_IN_OUT
				)
				get_node("/root/World/GUI/TweenGreyscale").fade_out_greyscale()
				$Music.stop()
				$TimerDelaySelect.start()
				yield($TimerDelaySelect, "timeout")
				end_dialog()

func end_dialog():
	get_tree().paused = false
	Global.dialogOpen = false
	queue_free()
	Global.reset_input_after_dialog()

func reset_options():
	for option in $OptionsRect/Options.get_children():
		option.queue_free()

func _on_option_selected(option, variable, value):
	Global.custom_variables[variable] = value
	waiting_for_answer = false
	advance_dialog(int(value['skip']))
	reset_options()
	load_dialog()
	print('[!] Option selected: ', option.text, ' \\//\\ value = ' , value)
	
func _on_level_selected(value):
	stats_remaining -= 1
	# stats_remaining_label.set_visible_characters(stats_remaining)
	match value:
		"VIT": VIT_to_add += 1
		"END": END_to_add += 1
		"DEF": DEF_to_add += 1
		"STR": STR_to_add += 1
		"DEX": DEX_to_add += 1
		"SPD": SPD_to_add += 1
		"MAG": MAG_to_add += 1
	if stats_remaining == 0:
		waiting_for_answer = false
		waiting_for_level = false
		waiting_for_input = false
		for x in $OptionsRect/LevelUp_Rect/LevelUp_Container/Options.get_children():
			x.focus_mode = 0
#		$Tween.interpolate_property($LevelText, "modulate",
#			Color(1, 1, 1, 1),
#			Color(1, 1, 1, 0),
#			0.6,
#			Tween.TRANS_QUINT, Tween.EASE_IN
#			)
		$Tween.interpolate_property($OptionsRect, "modulate",
			Color(1, 1, 1, 1),
			Color(1, 1, 1, 0),
			0.6,
			Tween.TRANS_QUINT, Tween.EASE_IN
			)
		$Tween.interpolate_property($LevelDescription, "modulate",
			Color(1, 1, 1, 1),
			Color(1, 1, 1, 0),
			0.6,
			Tween.TRANS_QUINT, Tween.EASE_IN
			)
		$Tween.interpolate_property($StatPreview, "modulate",
			Color(1, 1, 1, 1),
			Color(1, 1, 1, 0),
			0.6,
			Tween.TRANS_QUINT, Tween.EASE_IN
			)
		$Tween.start()
		print(value, ' incremented... 0 stats remaining. stats to add:')
		if VIT_to_add > 0: print(VIT_to_add, ' VIT')
		if END_to_add > 0: print(END_to_add, ' END')
		if DEF_to_add > 0: print(DEF_to_add, ' DEF')
		if STR_to_add > 0: print(STR_to_add, ' STR')
		if DEX_to_add > 0: print(DEX_to_add, ' DEX')
		if SPD_to_add > 0: print(SPD_to_add, ' SPD')
		if MAG_to_add > 0: print(MAG_to_add, ' MAG')
		$TimerDelaySelect.start()
		yield($TimerDelaySelect, "timeout")
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
	MAG_to_add = 0

func apply_level_stats():
	if VIT_to_add > 0: print(VIT_to_add, ' VIT')
	if END_to_add > 0: print(END_to_add, ' END')
	if DEF_to_add > 0: print(DEF_to_add, ' DEF')
	if STR_to_add > 0: print(STR_to_add, ' STR')
	if DEX_to_add > 0: print(DEX_to_add, ' DEX')
	if SPD_to_add > 0: print(SPD_to_add, ' SPD')
	if MAG_to_add > 0: print(MAG_to_add, ' MAG')

func advance_dialog(skip_index):
	dialog_index += skip_index

func _on_TimerText_timeout():
	if label.get_visible_characters() <= label.get_total_character_count():
		$AudioStreamPlayer.play()
		label.set_visible_characters(label.get_visible_characters()+1)
	else:
		$AudioStreamPlayer.stop()
		$TimerText.stop()
		finished = true
		if waiting_for_answer:
			$Tween.interpolate_property($LevelText, "rect_position",
			Vector2(103, 53),
			Vector2(320, 53),
			0.6,
			Tween.TRANS_QUINT, Tween.EASE_IN
			)
			$Tween.start()
			$TimerDelaySelect.start()
			yield($TimerDelaySelect, "timeout")
			if level_flag:
				$Music.play()
				get_child(2).get_child(0).get_child(0).get_child(0).get_child(0).grab_focus()
				level_flag = false
				waiting_for_input = true
				# stats_remaining_label.set_visible_characters(1)
			else:
				print('not level flag: this should not happen')
				get_child(1).get_child(0).get_child(0).grab_focus()
				waiting_for_input = true
