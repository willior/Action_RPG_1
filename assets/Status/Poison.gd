extends Node

# Upon contracting poison, the count is set to 1, and the Timer (0.2s) starts
# each Timeout (0.2s), the poison_tick function is run;
# this function decrements the health by the potency amount,
# and increments the count by 1.
# Once the count reaches the duration amount,
# the Poison is removed following the subsequent tick.
# If the player contracts Poison while already Poisoned, the count is set to 0

export var count = 0
export var duration = 45 # number of ticks
export var potency = 1 # damage per tick

var active = false

func activate():
	PlayerStats.is_poisoned = true
	if $Timer.is_stopped():
		count = 1
		$Timer.start()
	else:
		count = 0

func poison_tick():
	PlayerStats.health -= potency
	count += 1

func _on_Timer_timeout():
	if count == duration:
		PlayerStats.is_poisoned = false
		poison_tick()
		PlayerStats.status = "poison_end"
	else:
		poison_tick()
		$Timer.start()
