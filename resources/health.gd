class_name Health
extends Resource

@export var health := 0


signal death()


func hit(body, damage: int):
	assert(damage >= 0)
	health -= damage
	if health <= 0:
		death.emit()
	

func heal(amount: int):
	assert(amount <= 0)
	health += amount
