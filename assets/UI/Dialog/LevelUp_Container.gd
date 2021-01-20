extends HBoxContainer

func _ready():
	get_child(0).get_child(0).grab_focus()

func _on_focus_entered():
	$AudioMenu.play()



func _on_ButtonVIT_pressed():
	pass # Replace with function body.


func _on_ButtonEND_pressed():
	pass # Replace with function body.


func _on_ButtonDEF_pressed():
	pass # Replace with function body.


func _on_ButtonSTR_pressed():
	pass # Replace with function body.


func _on_ButtonDEX_pressed():
	pass # Replace with function body.


func _on_ButtonSPD_pressed():
	pass # Replace with function body.
