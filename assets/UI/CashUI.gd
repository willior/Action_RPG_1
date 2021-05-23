extends Control

var currentCash setget set_cash

onready var cashBox = $HBoxContainer/Label

func set_cash(value):
	currentCash = str("%.2f" %value)
	cashBox.set_text("$ " + currentCash)
	
func _ready():
	self.currentCash = Player1Stats.cash
# warning-ignore:return_value_discarded
	Player1Stats.connect("cash_changed", self, "set_cash")
