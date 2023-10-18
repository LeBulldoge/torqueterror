class_name Dasher
extends Chaser

var is_dashing = false

var elapsed = 0
var target: Vector2
@export var dash_time = 1.0


func perform(enemy: Enemy):
    if enemy.position.distance_to(enemy.target.position) < 150 and not is_dashing:
        start_dash(enemy)
        return

    if is_dashing:
        dash(enemy)
        if elapsed >= dash_time:
            stop_dash()
    else:
        super.perform(enemy)


func dash(enemy: Enemy):
    enemy.position = enemy.position.lerp(target, (elapsed / dash_time * 0.1))
    elapsed += enemy.get_process_delta_time()


func start_dash(enemy: Enemy):
    is_dashing = true
    target = enemy.position + (-enemy.position.direction_to(enemy.target.position) * 200)


func stop_dash():
    elapsed = 0
    target = Vector2.ZERO
    is_dashing = false
