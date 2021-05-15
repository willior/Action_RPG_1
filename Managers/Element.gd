extends Node

# 0 : fire
# 1 : ice
# 2 : lightning
# 3 : water
# 4 : wind
# 5 : earth
# 6 : light
# 7 : dark
# 8 : verve
# 9 : death

enum {
	FIRE,
	ICE,
	LIGHTNING,
	WATER,
	WIND,
	EARTH,
	LIGHT,
	DARK,
	VERVE,
	DEATH
}

var FireMod = [0.5, 2, 1, 1, 1, 1, 1, 1, 1, 1]
var IceMod = [2, 0.5, 1, 1, 1, 1, 1, 1, 1, 1]
var LightningMod = [1, 1, 0.5, 2, 1, 1, 1, 1, 1, 1]
var WaterMod = [2, 0.5, 2, 0.5, 1, 1, 1, 1, 1, 1]
var WindMod = [1, 1, 1, 1, 2, 1, 1, 1, 1, 1]
var EarthMod = [1, 1, 2, 1, 0.5, 0.5, 1, 1, 1, 1]
var LightMod = [1, 1, 1, 1, 1, 1, 0.5, 2, 1, 1]
var DarkMod = [1, 1, 1, 1, 1, 1, 2, 0.5, 1, 1, ]
var VerveMod = [-1, -1, -1, -1, -1, -1, -1, -1, -1, 1]
var EntropyMod = [1, 1, 1, 1, 1, 1, 1, 1, 2, -1]

func _ready():
	for a in range(0,10):
		for b in range(0,10):
			calculate_element_ratio(a, b)

func calculate_element_ratio(source_element, target_element):
	var elementRatio = Array()
	match source_element:
		0: elementRatio = FireMod
		1: elementRatio = IceMod
		2: elementRatio = LightningMod
		3: elementRatio = WaterMod
		4: elementRatio = WindMod
		5: elementRatio = EarthMod
		6: elementRatio = LightMod
		7: elementRatio = DarkMod
		8: elementRatio = VerveMod
		9: elementRatio = EntropyMod
	print(source_element, " vs ", target_element, " = ", elementRatio[target_element])
	return elementRatio[target_element]
