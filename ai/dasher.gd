class_name Dasher
extends Chaser

var is_dashing = false

func perform(enemy: Enemy):
	if enemy.position.distance_to(enemy.target.position) < 150 && not is_dashing:
		await dash(enemy)


func dash(enemy: Enemy):
	is_dashing = true
	var elapsed = 0
	var dash_time = 1.0
	
	while elapsed < dash_time:
		enemy.position = enemy.position.lerp(enemy.position + -enemy.transform.x * 20, (elapsed / dash_time))
		elapsed += enemy.get_process_delta_time()
