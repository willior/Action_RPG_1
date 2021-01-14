extends Control

var health setget set_health
var max_health setget set_max_health

onready var healthBar = $HealthTexture
onready var healthBack = $HealthBack
onready var tween = $Tween
onready var stats = get_parent().get_node(get_parent().ENEMY_NAME+"Stats")

func show_health():
	tween.stop(self)
	$FadeTimer.start()
	self.show()
	self.modulate = Color(1,1,1,1)
	yield($FadeTimer, "timeout")
	tween.interpolate_property(
		self,
		"modulate",
		Color(1,1,1,1),
		Color(1,1,1,0),
		0.8,
		Tween.TRANS_QUART,
		Tween.EASE_IN
	)
	tween.start()
	yield(tween, "tween_all_completed")
	self.hide()

func set_health(value):
	health = value
	healthBar.value = health
	set_health_background(health)
	
func set_max_health(value):
	max_health = value
	healthBar.max_value = max_health
	healthBack.max_value = max_health
	
func set_health_background(value):
	if healthBack.value > value:
		healthBack.value -= 1
		$DrainTimer.start()
		yield($DrainTimer, "timeout")
		set_health_background(value)
	else:
		healthBack.value = value

func _ready():
	self.max_health = stats.max_health
	self.health = stats.health
# warning-ignore:return_value_discarded
	stats.connect("health_changed", self, "set_health")
# warning-ignore:return_value_discarded
	stats.connect("max_health_changed", self, "set_max_health")
