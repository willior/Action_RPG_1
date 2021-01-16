extends Node

onready var audio = $AudioStreamPlayer
onready var miss = load("res://assets/Audio/SFX/Miss.wav")
onready var level_up = load("res://assets/Audio/Player/Level_Up_Hit.wav")

func _ready():
	print("SoundPlayer initialized")
	
func play_sound(value):
	match value:
		"miss":
			audio.stream = miss
		"level_up":
			audio.stream = level_up
			
	audio.play()
	
		
