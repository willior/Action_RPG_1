extends Node

onready var audio = $AudioStreamPlayer
onready var miss = preload("res://assets/Audio/SFX/Miss.wav")
# onready var level_up = load("res://assets/Audio/Player/Level_Up_Hit.wav")
onready var crit = preload("res://assets/Audio/Player/Crit.wav")

onready var awesome = preload("res://assets/Audio/Gene/Awesome!.wav")
onready var great = preload("res://assets/Audio/Gene/Great!.wav")
onready var iloveit = preload("res://assets/Audio/Gene/I love it!.wav")
onready var nice = preload("res://assets/Audio/Gene/Nice!.wav")
onready var whistle = preload("res://assets/Audio/Gene/Whistle.wav")
onready var wow = preload("res://assets/Audio/Gene/Wow!.wav")

# onready var level_up_BGM = load("res://assets/Audio/Music/LevelUp.ogg")

func _ready():
	print("SoundPlayer initialized")
	
func play_sound(value):
	audio.bus = "Master"
	match value:
		"miss":
			audio.stream = miss
		"crit":
			$AudioStreamPlayer.bus = "ShortDelay"
			audio.stream = crit
#	
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

func play_music(value):
	print('playing music: ', value)
	#$Music.bus = "Reverb"
#	match value:
#		"level_up":
#			audio.stream = level_up_BGM
	$Music.play()
	
func stop_music():
	$Music.stop()
