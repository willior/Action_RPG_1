extends Node2D

const heartCollectSound = preload("res://assets/Audio/HeartCollect.wav")
const coinCollectSound = preload("res://assets/Audio/CoinCollect.wav")

onready var collectSound = $AudioStreamPlayer

enum {
	heart,
	coin
	}
	
func playSound(itemCollected):
	match(itemCollected):
		heart:
			collectSound.stream = heartCollectSound
			collectSound.play()
		coin:
			collectSound.stream = coinCollectSound
			collectSound.play()
		
func _on_AudioStreamPlayer_finished():
	queue_free()
