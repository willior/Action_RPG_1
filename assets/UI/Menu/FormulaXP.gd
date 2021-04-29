extends TextureProgress
var current_xp
var required_xp
func _ready():
	self.value = current_xp
	self.max_value = required_xp
	print('xp bar ready')
