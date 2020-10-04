extends ParallaxBackground

onready var overlay = $ParallaxLayerOverlay
onready var sprite = $ParallaxLayerOverlay/Sprite

func _ready():
	pass
	
func _process(delta):
	print('processing')
	overlay.motion_offset.x += 0.2
	overlay.motion_offset.y += 0.2
	#if overlay.motion_offset.x == 320: sprite.offset.x = 0
	#if overlay.motion_offset.y == 180: sprite.offset.y = 0
