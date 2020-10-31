extends Node

const DialogBox = preload("res://assets/UI/Dialog.tscn")

func item_handler(item_used):
	# 0 Consumable
	# 1 Tool
	# 2
	# 4
	match item_used.type:
		0:
			pass
		1:
			match item_used.name:
				"Metal_Pot":
					GameManager.player.audio.stream = load("res://assets/Audio/CoinCollect.wav")
					GameManager.player.audio.play()
					use_metal_pot()
		2:
			pass
		3:
			pass
					
func use_metal_pot():
	var dialogBox = DialogBox.instance()
	if PlayerLog.metal_pot_use_index == 0:
		dialogBox.dialog = [
			"I guess I'm not so useless after all. I play a sound effect."
		]
		get_node("/root/World/GUI").add_child(dialogBox)
		
	if PlayerLog.metal_pot_use_index == 4:
		dialogBox.dialog = [
			"Pretty neat!!"
		]
		get_node("/root/World/GUI").add_child(dialogBox)
		
	PlayerLog.metal_pot_use_index += 1
