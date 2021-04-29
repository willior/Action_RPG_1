extends HBoxContainer
var formula_name : String
var formula_level : int
var ing_1_icon : Texture
var ing_1_cost : int
var ing_2_icon : Texture
var ing_2_cost : int
var formula_icon : SpriteFrames

func _ready():
	$Name.set_text(formula_name)
	$Level.set_text(" Lv." + str(formula_level))
	$Ingredient1.texture = ing_1_icon
	$Cost1.set_text(str(ing_1_cost))
	$Ingredient2.texture = ing_2_icon
	$Cost2.set_text(str(ing_2_cost))
	$SpriteContainer/AnimatedSprite.frames = formula_icon
