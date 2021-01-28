extends Node

onready var audio = $AudioStreamPlayer
onready var miss = load("res://assets/Audio/SFX/Miss.wav")
onready var level_up = load("res://assets/Audio/Player/Level_Up_Hit.wav")
onready var crit = load("res://assets/Audio/Player/Crit.wav")

func _ready():
	print("SoundPlayer initialized")
	
func play_sound(value):
	$AudioStreamPlayer.bus = "Master"
	match value:
		"miss":
			audio.stream = miss
		"level_up":
			audio.stream = level_up
		"crit":
			$AudioStreamPlayer.bus = "ShortDelay"
			audio.stream = crit
	audio.play()
	
		
