class_name Health
extends Resource


@export var max_health: int

var current_health: int

signal death()


func reset():
	current_health = max_health


func take_damage(damage: int):
	assert(damage >= 0)
	current_health -= damage
	if current_health <= 0:
		death.emit()

func heal(amount: int):
	assert(amount <= 0)
	current_health += amount
