extends Node

export(int) var max_health = 1
onready var health = max_health setget

signal no_health
