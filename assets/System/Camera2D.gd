extends Camera2D

var player1pos
var player2pos

func _ready():
	if GameManager.multiplayer_2:
		get_node("/root/World/YSort/Player/RemoteTransform2D").queue_free()
		print('multiplayer detected: deleting transform')
	else:
		set_process(false)

func _process(_delta):
	player1pos = get_node("/root/World/YSort/Player").position
	
	player2pos = get_node("/root/World/YSort/Player2").position
	position = (player1pos + player2pos)/2
