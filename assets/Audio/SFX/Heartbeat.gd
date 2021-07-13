extends AudioStreamPlayer

var fast_heartbeat = load("res://assets/Audio/SFX/heartbeat_fast.wav")

func _ready():
# warning-ignore:return_value_discarded
	Player1Stats.connect("final_health_changed", self, "adjust_heartbeat")
# warning-ignore:return_value_discarded
	Player2Stats.connect("final_health_changed", self, "adjust_heartbeat")

func adjust_heartbeat(value):
	if value == 12:
		stream = fast_heartbeat
		play()
