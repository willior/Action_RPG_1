extends Button
const DialogBox = preload("res://assets/UI/Dialog/PopupDialogBox.tscn")
onready var pauseMenu = get_parent().get_parent().get_parent().get_parent().get_parent()
onready var pouchButton = pauseMenu.get_node("MenuPanel/Menu/ButtonPouch")
var description

func _ready():
	self.focus_neighbour_left = pouchButton.get_path()

func _on_Button_gui_input(event):
	if event.is_action_pressed(pauseMenu.controls.examine):
		pauseMenu.hide_pouch_display()
		pauseMenu.enable_menu_focus()
		pouchButton.grab_focus()
	elif event.is_action_pressed(pauseMenu.controls.attack):
		pauseMenu.audio_menu_select()
	elif event.is_action_pressed(pauseMenu.controls.start):
		pauseMenu.hide_pouch_display()
		pauseMenu.close_pause_menu()

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
