extends Resource
class_name FormulaResource
# Formula

export var name : String
export var icon : SpriteFrames
export var description : Array
enum formulaType { HEAL, DAMAGE, BUFF, DEBUFF }
export(formulaType) var type
export var cost : Dictionary
export var potency : int
