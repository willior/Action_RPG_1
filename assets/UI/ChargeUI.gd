extends Control

onready var progress = $TextureProgress
onready var animation = $TextureProgress/AnimationPlayer

# onready var player = get_parent().get_parent().get_node("YSort/Player")
# onready var player = $root/World/YSort/Player
var currentCharge = 0 setget set_charge

func _ready():
	set('z_index', 99)
	self.currentCharge = PlayerStats.charge
	PlayerStats.connect("charge_changed", self, "set_charge")

func begin_charge():
	print('begin_charge func')
	progress.visible = true

func set_charge(value):
	currentCharge = value
	progress.value = currentCharge
	if currentCharge == PlayerStats.max_charge:
		print('playing charge animation')
		animation.play("ChargeFlash")
		
func stop_charge():
	progress.visible = false
	animation.stop(true)
	animation.seek(0, true)
	print('stopping charge & animation')
