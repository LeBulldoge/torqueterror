class_name Attacker
extends AIModule


func setup(enemy: Enemy):
    enemy.weapon.area_entered.connect(_on_weapon_area_entered.bind(enemy))
    enemy.weapon.area_exited.connect(_on_weapon_area_exited.bind(enemy))


func _on_weapon_area_entered(body: Area2D, enemy: Enemy) -> void:
    if not body is HitBoxComponent:
        print("Detected wrong body type " + body.to_string())
        return

    enemy.set_state(Enemy.State.Attacking)
    enemy.weapon.start_attack(body)


func _on_weapon_area_exited(_body: Area2D, enemy: Enemy) -> void:
    enemy.set_state(Enemy.State.Free)
    enemy.weapon.stop_attack()
