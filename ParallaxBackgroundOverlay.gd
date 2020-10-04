extends ParallaxBackground

onready var overlay = $ParallaxLayerOverlay
	
func _process(_delta):
	overlay.motion_offset.x += 0.2
	overlay.motion_offset.y += 0.2
	if overlay.motion_offset.x == 320:
		overlay.offset.x = 0
		print('resetting x overlay')
	if overlay.motion_offset.y == 180:
		overlay.offset.y = 0
		print('resetting y overlay')
