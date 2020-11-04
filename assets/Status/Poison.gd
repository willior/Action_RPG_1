extends Node

# Upon contracting poison, the count is set to 1, and the Timer (3s) starts
# each Timeout (3s), the poison_tick function is run;
# this function decrements the health by the potency amount,
# and increments the count by 1.
# Once the count reaches the duration amount,
# the Poison is removed following the subsequent tik.
# If the player contracts Poison while already Poisoned, the count is set to 0

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
