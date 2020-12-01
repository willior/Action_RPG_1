extends Node

const DialogBox = preload("res://assets/UI/DialogBox.tscn")

func item_handler(item_used):
	# 0 Consumable
	# 1 Tool
	# 2 Quest
	match item_used.type:
		0:
			PlayerStats.health += item_used.healing
			GameManager.player.audio.stream = load("res://assets/Audio/Slither_02.wav")
			GameManager.player.audio.play()
		1:
			pass
		2:
			match item_used.name:
				"Metal_Pot":
					GameManager.player.audio.stream = load("res://assets/Audio/CoinCollect.wav")
					GameManager.player.audio.play()
					use_metal_pot()

func use_metal_pot():
	var dialogBox = DialogBox.instance()
	if PlayerLog.metal_pot_use_index == 2:
		dialogBox.dialog_script = [
			{'text': "I guess I'm not so useless after all. I play a sound effect."}
		]
		get_node("/root/World/GUI").add_child(dialogBox)
		
	if PlayerLog.metal_pot_use_index == 6:
		dialogBox.dialog_script = [
			{'text': "Pretty neat!!"}
		]
		get_node("/root/World/GUI").add_child(dialogBox)
		
	PlayerLog.metal_pot_use_index += 1
