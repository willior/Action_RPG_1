extends Control

onready var gameOverFlash = $White
onready var tween = $Tween
onready var timer = $Timer

func _ready():
	print('GAME OVER')
	$AudioStreamPlayer.play()
	tween.interpolate_property(gameOverFlash,
	"color",
	Color(1, 1, 1, 1),
	Color(1, 1, 1, 0),
	6,
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
	6,
	Tween.TRANS_LINEAR,
	Tween.EASE_IN
	)
	tween.start()
	timer.wait_time = 7.9
	timer.start()
	
	yield(timer, "timeout")
	$Label.visible = true
	
func _input(event):
	if event.is_action_pressed("start"):
		prints('continue #', PlayerStats.continue_count)

#func _process(delta):
	#if Input.is_action_just_pressed("start"):
		
