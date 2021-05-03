extends Control
var pouch_ingredient
func _ready():
	$HBoxContainer/TextureRect.set_texture(pouch_ingredient.ingredient_reference.texture)
	$HBoxContainer/Label.set_text(str(pouch_ingredient.ingredient_reference.name) + " x" + str(pouch_ingredient.quantity))
	$Button.description = pouch_ingredient.ingredient_reference.description
