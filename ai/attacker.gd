class_name Attacker
extends AIModule


func perform(enemy: Enemy):
	if enemy.position.distance_to(enemy.target.position) < enemy.weapon.range:
		shoot(enemy)


func shoot(enemy: Enemy):
	if enemy.weapon.is_attack_on_cooldown():
		return

	enemy.weapon.attack(enemy.target.health)
