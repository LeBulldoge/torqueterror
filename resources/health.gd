class_name Health
extends Resource


@export var max_health: int

signal health_changed(health: int)
signal death()
var current_health: int :
	set(value):
		current_health = value
		health_changed.emit(current_health)
		
		if current_health <= 0:
			death.emit()


func _init(max: int = 0):
	max_health = max


func reset():
	current_health = max_health
	health_changed.emit(current_health)

func take_damage(damage: int):
	assert(damage >= 0)
	current_health -= damage
	if current_health <= 0:
		death.emit()

func heal(amount: int):
	assert(amount <= 0)
	current_health += amount
