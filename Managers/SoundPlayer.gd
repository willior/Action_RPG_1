extends Node

onready var audio = $AudioStreamPlayer

var miss = preload("res://assets/Audio/SFX/Miss.wav")
var crit = preload("res://assets/Audio/Player/Crit.wav")
var slither = preload("res://assets/Audio/Slither_02.wav")

var awesome = preload("res://assets/Audio/Gene/Awesome!.wav")
var great = preload("res://assets/Audio/Gene/Great!.wav")
var iloveit = preload("res://assets/Audio/Gene/I love it!.wav")
var nice = preload("res://assets/Audio/Gene/Nice!.wav")
var whistle = preload("res://assets/Audio/Gene/Whistle.wav")
var wow = preload("res://assets/Audio/Gene/Wow!.wav")

func play_sound(value):
	if audio.bus != "Master":
		audio.bus = "Master"
	match value:
		"miss":
			audio.stream = miss
		"crit":
			audio.bus = "ShortDelay"
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
		"slither":
			audio.stream = slither
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
