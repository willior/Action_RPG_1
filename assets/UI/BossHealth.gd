extends Control

var health setget set_health
var max_health setget set_max_health

onready var healthBar = $HealthTexture
onready var healthBack = $HealthBack
onready var tween = $Tween
onready var stats = get_parent().get_parent().get_node("Stats") # get_owner().get_node(get_owner().ENEMY_NAME+"Stats")
onready var nametag = get_parent().get_parent().ENEMY_NAME

func _ready():
	self.max_health = stats.max_health
	self.health = stats.health
# warning-ignore:return_value_discarded
	stats.connect("health_changed", self, "set_health")
# warning-ignore:return_value_discarded
	stats.connect("max_health_changed", self, "set_max_health")

func show_health():
	if self.visible: return
	self.show()
	tween.interpolate_property(
		self,
		"modulate",
		Color(1,1,1,0),
		Color(1,1,1,1),
		0.4,
		Tween.TRANS_QUART,
		Tween.EASE_IN
	)
	tween.start()
	yield(tween, "tween_all_completed")

func set_health(value):
	health = value
	healthBar.value = health
	set_health_background(health)
	# visible = false
	# call_deferred("set_visible", true)
	
func set_max_health(value):
	max_health = value
	healthBar.max_value = max_health
	healthBack.max_value = max_health
	
func set_health_background(value):
	if healthBack.value > value:
		healthBack.value -= 2
		$DrainTimer.start()
		yield($DrainTimer, "timeout")
		set_health_background(value)
	else:
		healthBack.value = value

func _on_stats_no_health():
	pass
#	yield(get_tree().create_timer(2.0), "timeout")
#	queue_free()
