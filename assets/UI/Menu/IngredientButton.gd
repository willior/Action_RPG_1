extends Button
const DialogBox = preload("res://assets/UI/Dialog/PopupDialogBox.tscn")
onready var pouchButton = get_parent().get_parent().get_parent().get_parent().get_node("MenuPanel/Menu/ButtonPouch")
var description

func _ready():
	self.focus_neighbour_left = pouchButton.get_path()

func _on_Button_gui_input(event):
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_left"):
		pouchButton.grab_focus()
	if event.is_action_pressed("ui_select"):
		get_parent().get_parent().get_parent().get_parent().audio_menu_select()

func _on_Button_pressed():
	var dialogBox = DialogBox.instance()
	dialogBox.dialog_script = description
#
#	dialogBox.dialog_script = [
#		{
#			"text": description
#		}
#	]
	get_node("/root/World/GUI").add_child(dialogBox)
