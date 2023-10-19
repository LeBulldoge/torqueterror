class_name Chaser
extends AIModule


func perform(enemy: Enemy):
    enemy.look_at(enemy.target.position)
    if enemy.state == Enemy.State.Free:
        enemy.set_state(Enemy.State.Moving)


func perform_physics(enemy: Enemy):
    if enemy.state == Enemy.State.Moving:
        walk(enemy)


func walk(enemy: Enemy):
    var delta = enemy.get_physics_process_delta_time()
    enemy.velocity = enemy.transform.x * enemy.speed
    enemy.move_and_slide()
