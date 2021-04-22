extends Control

onready var label = $RichTextLabel
var description : String

func update_description(text):
	label.bbcode_text = text

func _on_ButtonVIT_focus_entered(stat_color):
	description = ""
	update_description(description)
	$NinePatchRect.modulate = Color(stat_color)

func _on_ButtonEND_focus_entered(stat_color):
	description = ""
	update_description(description)
	$NinePatchRect.modulate = Color(stat_color)

func _on_ButtonDEF_focus_entered(stat_color):
	description = ""
	update_description(description)
	$NinePatchRect.modulate = Color(stat_color)

func _on_ButtonSTR_focus_entered(stat_color):
	description = ""
	update_description(description)
	$NinePatchRect.modulate = Color(stat_color)

func _on_ButtonDEX_focus_entered(stat_color):
	description = ""
	update_description(description)
	$NinePatchRect.modulate = Color(stat_color)

func _on_ButtonSPD_focus_entered(stat_color):
	description = ""
	update_description(description)
	$NinePatchRect.modulate = Color(stat_color)
	
func _on_ButtonMAG_focus_entered(stat_color):
	description = ""
	update_description(description)
	$NinePatchRect.modulate = Color(stat_color)
