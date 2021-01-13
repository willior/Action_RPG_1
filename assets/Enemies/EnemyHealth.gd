extends Control

var health setget set_health
var max_health setget set_max_health

onready var healthBar = $HealthTexture
onready var timer = $Timer
onready var stats = get_parent().get_node(get_parent().ENEMY_NAME+"Stats")

func show_health():
	timer.start()
	self.show()
	yield(timer, "timeout")
	self.hide()

func set_health(value):
	health = value
	healthBar.value = health
func set_max_health(value):
	max_health = value
	healthBar.max_value = max_health
	# healthBar.rect_size.x = max_health

func _ready():
	self.max_health = stats.max_health
	self.health = stats.health
# warning-ignore:return_value_discarded
	stats.connect("health_changed", self, "set_health")
# warning-ignore:return_value_discarded
	stats.connect("max_health_changed", self, "set_max_health")
