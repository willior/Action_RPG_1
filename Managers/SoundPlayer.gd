extends Node

onready var audio = $AudioStreamPlayer
onready var miss = load("res://assets/Audio/SFX/Miss.wav")
onready var level_up = load("res://assets/Audio/Player/Level_Up_Hit.wav")
onready var crit = load("res://assets/Audio/Player/Crit.wav")

onready var awesome = load("res://assets/Audio/Gene/Awesome!.wav")
onready var great = load("res://assets/Audio/Gene/Great!.wav")
onready var iloveit = load("res://assets/Audio/Gene/I love it!.wav")
onready var nice = load("res://assets/Audio/Gene/Nice!.wav")
onready var whistle = load("res://assets/Audio/Gene/Whistle.wav")
onready var wow = load("res://assets/Audio/Gene/Wow!.wav")

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
		
		"awesome":
			audio.stream = awesome
		"great":
			audio.stream = great
		"iloveit":
			audio.stream = iloveit
		"nice":
			audio.stream = nice
		"whistle":
			audio.stream = whistle
		"wow":
			audio.stream = wow
	
	audio.play()
	
		
