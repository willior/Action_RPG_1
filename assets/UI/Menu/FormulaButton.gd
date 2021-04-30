extends Button

onready var alchemyButton = get_parent().get_parent().get_parent().get_node("MenuPanel/Menu/ButtonAlchemy")

func _ready():
	self.focus_neighbour_left = alchemyButton.get_path()

func _on_Button_gui_input(event):
	if event.is_action_pressed("ui_cancel"):
		alchemyButton.grab_focus()
	if event.is_action_pressed("ui_select"):
		get_parent().get_parent().get_parent().audio_menu_select()
