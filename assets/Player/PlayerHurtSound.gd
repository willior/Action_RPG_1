extends AudioStreamPlayer

func _ready():
	print('player hurt sound')
	connect("finished", self, "delete")

func delete():
	queue_free()
