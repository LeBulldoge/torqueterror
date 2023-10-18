extends Node
class_name HealthComponent

@export var MAX_HEALTH: float = 100.0
var health: float

signal health_changed(health: float)
signal death()


func _ready():
	health = MAX_HEALTH


func damage(value: float):
	health -= value
	health_changed.emit(health)

	if health <= 0:
		death.emit()
