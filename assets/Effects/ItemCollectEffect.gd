extends Node2D

onready var HeartSoundPlayer = get_parent().get_parent().get_node("HeartSound")
onready var CoinSoundPlayer = get_parent().get_parent().get_node("CoinSound")

enum {
	heart,
	coin
	}
	
func playSound(itemCollected):
	match(itemCollected):
		heart:
			print('playing heart')
			HeartSoundPlayer.play()
		coin:
			print('playing coin')
			CoinSoundPlayer.play()
