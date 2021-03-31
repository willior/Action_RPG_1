extends Node

const DialogBox = preload("res://assets/UI/DialogBox.tscn")

func item_handler(item_used, player):
	# 0 Consumable
	# 1 Tool
	# 2 Quest
	match item_used.type:
		0:
			match player:
				1:
					if PlayerStats.dying:
						PlayerStats.health += item_used.healing/3
					else:
						PlayerStats.health += item_used.healing
				2:
					if Player2Stats.dying:
						Player2Stats.health += item_used.healing/3
					else:
						Player2Stats.health += item_used.healing
			
#			GameManager.player.audio.stream = load("res://assets/Audio/Slither_02.wav")
#			GameManager.player.audio.play()
			SoundPlayer.play_sound("slither")
