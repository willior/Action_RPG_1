extends Node

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
					use_metal_pot()
		2:
			pass
		3:
			pass
					
func use_metal_pot():
	GameManager.player.audio.stream = load("res://assets/Audio/CoinCollect.wav")
	GameManager.player.audio.play()
