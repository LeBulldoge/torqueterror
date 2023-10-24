extends Node
class_name HealthComponent

@export var MAX_HEALTH: float = 100.0
var health: float

signal health_changed(health: float)
signal max_health_changed(new_max: float)
signal death()


func _ready():
    health = MAX_HEALTH


func damage(value: float):
    if value <= 0:
        return

    health -= value
    health_changed.emit(health)

    if health <= 0:
        death.emit()


func heal(value: float):
    if value <= 0:
        return

    health += value
    health_changed.emit(health)


func increase_health(value: float):
    MAX_HEALTH += value
    max_health_changed.emit(MAX_HEALTH)
    heal(value)
