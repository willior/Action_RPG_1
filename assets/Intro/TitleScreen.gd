extends Node

# to change which runs when the program starts
# project settings > general tab > application > run > Main Scene

onready var audio = $AudioStreamPlayer
onready var label1 = $MarginContainer/VBoxContainer/Label1
onready var label2 = $MarginContainer/VBoxContainer/Label2
onready var wisteria = $Wisteria
onready var tween = $Tween
onready var timer = $Timer
onready var iggy = $MarginContainer/VBoxContainer/HBoxContainer/Iggy
onready var ziggy = $MarginContainer/VBoxContainer/HBoxContainer/Ziggy
onready var title = $Title
onready var titleMenu = $MarginContainer/TitleMenu
onready var newGameButton = $MarginContainer/TitleMenu/NewGame
onready var quitGameButton = $MarginContainer/TitleMenu/QuitGame
onready var menuTimer = $MenuTimer

var transTime = 2
var menuOn = false

func _process(delta):
	if Input.is_action_just_pressed("start") && !menuOn:
		titleMenu()

func _ready():
	
	while !menuOn:
		
		label1.visible = false
		
		timer.start()
		yield(timer, "timeout")
		
		audio.play()
		label1.visible = true
		
		timer.wait_time = transTime
		timer.start()
		yield(timer, "timeout")
	
		# fading in "presents"
		tween.interpolate_property(label2,
		"modulate",
		Color(1, 1, 1, 0),
		Color(1, 1, 1, 1),
		transTime,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
		)
		tween.start()
		
		timer.start()
		yield(timer, "timeout")
		
		# fading out "WGS presents"
		tween.interpolate_property(label1,
		"modulate",
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 0),
		transTime,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
		)
		tween.start()
		tween.interpolate_property(label2,
		"modulate",
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 0),
		transTime,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
		)
		tween.start()
	
		timer.start()
		yield(timer, "timeout")
		
		label1.text = "a game by"
		label2.text = "Will Graham-Simpkins"
		# fading in "a game by"
		tween.interpolate_property(label1,
		"modulate",
		Color(1, 1, 1, 0),
		Color(1, 1, 1, 1),
		transTime,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
		)
		tween.start()
	
		timer.start()
		yield(timer, "timeout")
		# "WGS"
		tween.interpolate_property(label2,
		"modulate",
		Color(1, 1, 1, 0),
		Color(1, 1, 1, 1),
		transTime,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
		)
		tween.start()
		
		timer.start()
		yield(timer, "timeout")
		#fading out "a game by WGS"
		tween.interpolate_property(label1,
		"modulate",
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 0),
		transTime,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
		)
		tween.start()
		tween.interpolate_property(label2,
		"modulate",
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 0),
		transTime,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
		)
		tween.start()
	
		timer.start()
		yield(timer, "timeout")
		
		tween.interpolate_property(wisteria,
		"modulate",
		Color(1, 1, 1, 0),
		Color(1, 1, 1, 1),
		transTime,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
		)
		tween.start()
		
		timer.wait_time = transTime * 2
		timer.start()
		yield(timer, "timeout")
		
		tween.interpolate_property(wisteria,
		"modulate",
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 0),
		transTime,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
		)
		tween.start()
		
		timer.wait_time = transTime
		timer.start()
		yield(timer, "timeout")
		
		label1.text = "in association with"
		tween.interpolate_property(label1,
		"modulate",
		Color(1, 1, 1, 0),
		Color(1, 1, 1, 1),
		transTime,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
		)
		tween.start()
		
		timer.start()
		yield(timer, "timeout")
		
		tween.interpolate_property(iggy,
		"modulate",
		Color(1, 1, 1, 0),
		Color(1, 1, 1, 1),
		transTime,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
		)
		tween.start()
		
		timer.start()
		yield(timer, "timeout")
		
		tween.interpolate_property(ziggy,
		"modulate",
		Color(1, 1, 1, 0),
		Color(1, 1, 1, 1),
		transTime,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
		)
		tween.start()
		
		timer.wait_time = transTime * 2
		timer.start()
		yield(timer, "timeout")
		
		
		tween.interpolate_property(label1,
		"modulate",
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 0),
		transTime,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
		)
		tween.start()
		tween.interpolate_property(iggy,
		"modulate",
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 0),
		transTime,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
		)
		tween.start()
		tween.interpolate_property(ziggy,
		"modulate",
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 0),
		transTime,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
		)
		tween.start()
		
		timer.wait_time = transTime
		timer.start()
		yield(timer, "timeout")
		
		titleMenu()
	
func titleMenu():
	
	menuOn = true
	
	timer.queue_free()
	label1.queue_free()
	label2.queue_free()
	iggy.queue_free()
	ziggy.queue_free()
	
	tween.interpolate_property(title,
	"modulate",
	Color(1, 1, 1, 0),
	Color(1, 1, 1, 1),
	transTime * 1.5,
	Tween.TRANS_QUAD,
	Tween.EASE_IN
	)
	tween.start()
	
	menuTimer.wait_time = transTime
	menuTimer.start()
	yield(menuTimer, "timeout")
	
	tween.interpolate_property(titleMenu,
	"modulate",
	Color(1, 1, 1, 0),
	Color(1, 1, 1, 1),
	transTime / 2,
	Tween.TRANS_QUAD,
	Tween.EASE_IN
	)
	tween.start()

	menuTimer.wait_time = transTime /2
	menuTimer.start()
	yield(menuTimer, "timeout")
	newGameButton.grab_focus()

func _on_NewGame_pressed():
	get_tree().change_scene("res://World.tscn")

func _on_QuitGame_pressed():
	get_tree().quit()