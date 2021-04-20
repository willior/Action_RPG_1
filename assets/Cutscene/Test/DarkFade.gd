extends CanvasLayer
var blackpixel = preload("res://assets/Misc/BlackPixel.png")
var redpixel = preload("res://assets/Misc/RedPixel.png")
func fade_to_dark():
	$Sprite.texture = blackpixel
	$Tween.interpolate_property($Sprite, "modulate",
		Color(1,1,1,0), Color(1,1,1,0.8), 3,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT
		)
	$Tween.interpolate_property(get_node("/root/World/SFX"), "volume_db",
		0, -32, 2.5,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT
		)
	$Tween.interpolate_property(get_node("/root/World/SFX2"), "volume_db",
		0, -32, 2.5,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT
		)
	$Tween.interpolate_property(get_node("/root/World/Music"), "volume_db",
		0, -32, 2.5,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT
		)
	$Tween.start()

func fade_to_light():
	$Tween.interpolate_property($Sprite, "modulate",
		Color(1,1,1,0.8), Color(1,1,1,0), 2.5,
		Tween.TRANS_QUAD, Tween.EASE_IN
		)
	$Tween.interpolate_property(get_node("/root/World/SFX"), "volume_db",
		-32, 0, 2.5,
		Tween.TRANS_QUAD, Tween.EASE_IN
		)
	$Tween.interpolate_property(get_node("/root/World/SFX2"), "volume_db",
		-32, 0, 2.5,
		Tween.TRANS_QUAD, Tween.EASE_IN
		)
	$Tween.interpolate_property(get_node("/root/World/Music"), "volume_db",
		-32, 0, 2.5,
		Tween.TRANS_QUAD, Tween.EASE_IN
		)
	$Tween.start()

func red_screen():
	$Sprite.texture = redpixel
	$Tween.interpolate_property($Sprite, "modulate",
		Color(1,1,1,0), Color(1,0,0,0.5), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN
		)
	$Tween.start()
	
func screen_shake1():
	# get_node("/root/World/Camera2D/ScreenShake").start(0.1, 32, 1, 0)
	get_node("/root/World/Camera2D").decay = 0
	get_node("/root/World/Camera2D").add_trauma(0.15)
func screen_shake2():
	# get_node("/root/World/Camera2D/ScreenShake").start(0.1, 64, 2, 0)
	get_node("/root/World/Camera2D").add_trauma(0.15)
func screen_shake3():
	# get_node("/root/World/Camera2D/ScreenShake").start(0.1, 80, 3, 0)
	get_node("/root/World/Camera2D").add_trauma(0.15)
func screen_shake4():
	# get_node("/root/World/Camera2D/ScreenShake").start(0.1, 88, 6, 0)
	get_node("/root/World/Camera2D").add_trauma(0.15)
func screen_shake5():
	# get_node("/root/World/Camera2D/ScreenShake").start(0.1, 96, 9, 0)
	get_node("/root/World/Camera2D").decay = 1
	get_node("/root/World/Camera2D").add_trauma(0.15)
