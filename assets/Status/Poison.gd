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

func _ready():
	activate()

func activate():
	if !$PoisonNotice.playing:
		$PoisonNotice.play()
		count = 1
	else:
		count = 0

func _on_PoisonNotice_animation_finished():
	poison_tick()
	if count == duration:
		queue_free()
	else:
		count += 1

func poison_tick():
	if body.stats.health <= 0:
		queue_free()
	else:
		body.stats.health -= potency
		if body.get("enemyHealth"):
			body.enemyHealth.show_health()
		body.hurtbox.display_damage_popup(str(potency), false, "Poison")
