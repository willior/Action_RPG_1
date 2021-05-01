extends AnimatedSprite

var speed = 1
var speed_mod = randf()

func _ready():
	pass # Replace with function body.

func _process(_delta):
	position.x += speed + speed_mod
	position.y += speed_mod
