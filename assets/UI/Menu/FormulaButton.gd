extends Button
const DialogBox = preload("res://assets/UI/Dialog/PopupDialogBox.tscn")
onready var pauseMenu = get_parent().get_parent().get_parent()
onready var alchemyButton = pauseMenu.get_node("MenuPanel/Menu/ButtonAlchemy")
var description

func _ready():
	self.focus_neighbour_left = alchemyButton.get_path()

func _on_Button_gui_input(event):
	if event.is_action_pressed("ui_cancel"):
		pauseMenu.hide_alchemy_display()
		pauseMenu.enable_menu_focus()
		alchemyButton.grab_focus()
	elif event.is_action_pressed("ui_accept"):
		pauseMenu.audio_menu_select()
	elif event.is_action_pressed(pauseMenu.start):
		pauseMenu.hide_alchemy_display()
		pauseMenu.close_pause_menu()

func _on_Button_pressed():
	var dialogBox = DialogBox.instance()
	dialogBox.dialog_script = [
		{
			"text": description
		}
	]
	get_node("/root/World/GUI").add_child(dialogBox)
