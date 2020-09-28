extends Node2D

var heartCollectSound = load("res://assets/Audio/HeartCollect.wav")
var coinCollectSound = load("res://assets/Audio/CoinCollect.wav")

var explode = load("res://assets/Audio/EnemyDie.wav")

onready var soundPlayer = get_parent().get_parent().get_node("Sounds")

enum {
	heart,
	coin
	}
	
func playSound(itemCollected):
	
	match(itemCollected):
		heart:
			print('playing heart')
			soundPlayer.stream = heartCollectSound
			soundPlayer.play()
		coin:
			print('playing coin')
			soundPlayer.stream = coinCollectSound
			soundPlayer.play()

func _on_AudioStreamPlayer_finished():
	queue_free()
