extends Node2D

onready var collectSound = $AudioStreamPlayer

enum {
	heart,
	coin
	}
	
func playSound(itemCollected):
	print(itemCollected)
	match(itemCollected):
		heart:
			collectSound.stream = load("res://assets/Audio/HeartCollect.wav")
			collectSound.play()
		coin:
			collectSound.stream = load("res://assets/Audio/CoinCollect.wav")
			collectSound.play()
		
func _on_AudioStreamPlayer_finished():
	queue_free()
