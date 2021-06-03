extends Node2D
var player_spawn_pos = Vector2(288,72)
onready var timer = $Timer
onready var tween = $Tween
onready var shade = $CanvasModulate
onready var rain = $ParallaxOverlay/ParallaxLayerBackground/Rain/Particle2D
onready var lightning = $WeatherCanvas
onready var SFX = get_parent().get_node("SFX")

var weather_tween_time = 12

func _ready():
	pass

func _on_Timer_timeout():
	print('timeout!')
	rain_stop()

func rain_stop():
	tween.interpolate_property(shade,
		"color",
		Color(0.33, 0.35, 0.64),
		Color(1, 1, 1),
		weather_tween_time * 2,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
		)
	tween.interpolate_property(rain,
		"modulate",
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 0),
		weather_tween_time,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
		)
	tween.interpolate_property(SFX,
		"volume_db",
		0,
		-80,
		weather_tween_time * 3,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
		)
		
	tween.start()

func _on_Tween_tween_all_completed():
	print('rain gone')
	shade.queue_free()
	$ParallaxOverlay/ParallaxLayerBackground/Rain.queue_free()
	lightning.queue_free()
