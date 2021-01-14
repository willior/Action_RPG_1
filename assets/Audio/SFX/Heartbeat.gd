extends AudioStreamPlayer

var fast_heartbeat = load("res://assets/Audio/SFX/heartbeat_fast.wav")

func _ready():
# warning-ignore:return_value_discarded
	PlayerStats.connect("final_health_changed", self, "adjust_heartbeat")
	AudioServer.set_bus_effect_enabled(0, 0, true)
	
func adjust_heartbeat(value):
	if value == 12:
		stream = fast_heartbeat
		play()
