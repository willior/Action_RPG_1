extends Node

export var count = 0
export var duration = 3
export var potency = 1

func poison_tick():
	PlayerStats.health -= potency
	count += 1

func _on_Timer_timeout():
	print('poison tick: ' + str(duration-count) + ' ticks remain')
	if count == duration:
		poison_tick()
		PlayerStats.status = "not_poison"
	else:
		poison_tick()
		$Timer.start()
