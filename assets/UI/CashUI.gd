extends Control

var currentCash setget set_cash

onready var cashBox = $HBoxContainer/Label

func set_cash(value):
	currentCash = str(value)
	cashBox.set_text("$ " + currentCash)
	
func _ready():
	self.currentCash = PlayerStats.cash
# warning-ignore:return_value_discarded
	PlayerStats.connect("cash_changed", self, "set_cash")
