extends Camera2D

var player1pos
var player2pos
var state
enum {
	SOLO,
	MULTI_2
}

export (OpenSimplexNoise) var noise
export (float, 0, 1) var trauma = 0.0
export var time_scale = 400
var time = 0
export (float, 0, 1) var decay = 0.6
export var max_x = 32
export var max_y = 32

func _ready():
	if GameManager.multiplayer_2:
		get_node("/root/World/YSort/Player/RemoteTransform2D").queue_free()
		state = MULTI_2
	else:
		state = SOLO

func add_trauma(value):
	trauma = clamp(trauma + value, 0, 1)

func stop_shake():
	trauma = 0

func _process(delta):
	match state:
		SOLO:
			pass
		MULTI_2:
			player1pos = get_node("/root/World/YSort/Player").position
			player2pos = get_node("/root/World/YSort/Player2").position
			position = (player1pos + player2pos)/2
	
	time += delta
	var shake = pow(trauma, 2)
	offset.x = noise.get_noise_2d(time*time_scale, 0) * max_x * shake
	offset.y = noise.get_noise_2d(0, time*time_scale) * max_y * shake
	if trauma > 0:
		trauma = clamp(trauma - (delta * decay), 0, 1)
