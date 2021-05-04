extends Node2D

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
onready var body = get_parent()
var active = false

func _ready():
	activate()

func activate():
	if !$PoisonNotice.playing:
		$PoisonNotice.play()
		count = 1
	else:
		count = 0
#	if $Timer.is_stopped():
#		count = 1
#		$Timer.start()
#	else:
#		count = 0

func poison_tick():
	body.stats.health -= potency
	body.hurtbox.display_damage_popup(str(potency), false, "Poison")

func _on_Timer_timeout():
	if count == duration:
		poison_tick()
		queue_free()
	else:
		count += 1
		poison_tick()
		# $Timer.start()

func _on_PoisonNotice_animation_finished():
	if count == duration:
		poison_tick()
		queue_free()
	else:
		count += 1
		poison_tick()
		# $Timer.start()
