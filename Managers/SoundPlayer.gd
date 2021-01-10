extends Node

onready var audio = $AudioStreamPlayer
onready var miss = load("res://assets/Audio/SFX/Miss.wav")

func _ready():
	print("SoundPlayer initialized")
	
func play_sound(value):
	match value:
		"miss":
			audio.stream = miss
	
	audio.play()
