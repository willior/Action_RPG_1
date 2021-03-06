extends Control

onready var label = $RichTextLabel
var description : String

func update_description(text):
	label.bbcode_text = text
#	label.set_visible_characters(0)
#	$TimerText.start()

func _on_ButtonVIT_focus_entered(stat_color):
	# show()
	description = Player1Stats.vitality_description
	update_description(description)
	$NinePatchRect.modulate = Color(stat_color)

func _on_ButtonEND_focus_entered(stat_color):
	description = Player1Stats.endurance_description
	update_description(description)
	$NinePatchRect.modulate = Color(stat_color)

func _on_ButtonDEF_focus_entered(stat_color):
	description = Player1Stats.defense_description
	update_description(description)
	$NinePatchRect.modulate = Color(stat_color)

func _on_ButtonSTR_focus_entered(stat_color):
	description = Player1Stats.strength_description
	update_description(description)
	$NinePatchRect.modulate = Color(stat_color)

func _on_ButtonDEX_focus_entered(stat_color):
	description = Player1Stats.dexterity_description
	update_description(description)
	$NinePatchRect.modulate = Color(stat_color)

func _on_ButtonSPD_focus_entered(stat_color):
	description = Player1Stats.speed_description
	update_description(description)
	$NinePatchRect.modulate = Color(stat_color)
	
func _on_ButtonMAG_focus_entered(stat_color):
	description = Player1Stats.magic_description
	update_description(description)
	$NinePatchRect.modulate = Color(stat_color)
	
func _on_TimerText_timeout():
	if label.get_visible_characters() <= label.get_total_character_count():
		# $AudioStreamPlayer.play()
		label.set_visible_characters(label.get_visible_characters()+1)
	else:
		#$AudioStreamPlayer.stop()
		$TimerText.stop()
		# $Text/Sprite.show()
		# finished = true
