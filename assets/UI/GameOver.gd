extends Control

onready var gameOverFlash = $White
onready var tween = $Tween
onready var timer = $Timer

func _ready():
	tween.interpolate_property(gameOverFlash,
	"color",
	Color(1, 1, 1, 1),
	Color(1, 1, 1, 0),
	5,
	Tween.TRANS_LINEAR,
	Tween.EASE_IN
	)
	tween.start()
	timer.start()
	yield(timer, "timeout")
	tween.interpolate_property(gameOverFlash,
	"color",
	Color(0, 0, 0, 0),
	Color(0, 0, 0, 1),
	5,
	Tween.TRANS_LINEAR,
	Tween.EASE_IN
	)
	tween.start()
