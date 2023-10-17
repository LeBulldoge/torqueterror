class_name Attacker
extends AIModule


func perform(enemy: Enemy):
	enemy.look_at(enemy.target.global_position)
	
	if enemy.position.distance_to(enemy.target.position) < enemy.weapon.range:
		shoot(enemy)
	else:
		walk(enemy)


func shoot(enemy: Enemy):
	if enemy.weapon.is_attack_on_cooldown():
		return

	enemy.weapon.attack(enemy.target.health)


func walk(enemy: Enemy):
	var delta = enemy.get_process_delta_time()
	enemy.velocity = enemy.transform.x * enemy.speed * 50 * delta

	enemy.move_and_slide()
