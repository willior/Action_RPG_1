extends Line2D

var target
var point
var trailLength = 12
var not_stopped = true

func _ready():
	target = get_parent()

func _process(_delta):
	global_position = Vector2.ZERO
	global_rotation = 0
	point = target.global_position
	add_point(point)
	while get_point_count() > trailLength:
		remove_point(0)
	if get_parent().done and not_stopped:
		stop()

func stop():
	not_stopped = false
	$Timer.start()
	yield($Timer, "timeout")
	get_parent().queue_free()
