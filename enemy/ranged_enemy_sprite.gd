extends AnimatedSprite2D


func _on_ranged_enemy_state_changed(new_state: Enemy.State):
    if new_state == Enemy.State.Attacking:
        play("shoot")
    else:
        play("default")
