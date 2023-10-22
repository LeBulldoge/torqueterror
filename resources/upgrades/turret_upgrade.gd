class_name TurretUpgrade
extends Upgrade

var weapon_scene = preload("res://weapons/turret.tscn")

@export var damage := 0.0
@export var attack_range := 0.0
@export var attack_speed := 0.0

enum TurretWeaponSide { Left, Right }
@export var side: TurretWeaponSide

@export var position := Vector2.ZERO
@export var sprite: Texture2D


func apply(player: Player):
    var turrets := get_turrets(player.get_node("Weapons").get_children())
    if position != Vector2.ZERO:
        var turret = weapon_scene.instantiate()
        turret.position = position
        if side == TurretWeaponSide.Left:
            turret.scale = Vector2(1, -1)
        else:
            turret.scale = Vector2(-1, -1)
        player.get_node("Weapons").add_child(turret)
        turret.shoot_projectile.connect(player._on_shoot_projectile)
        turrets.append(turret)

    for turret in turrets:
        turret.scale = (turret.scale / abs(turret.scale))
        turret.damage = damage
        turret.attack_speed = attack_speed
        turret.attack_range = attack_range


func get_turrets(weapons: Array[Node]) -> Array[TurretWeapon]:
    var turrets: Array[TurretWeapon] = []
    for weapon in weapons:
        if weapon is TurretWeapon:
            turrets.append(weapon)
    return turrets
