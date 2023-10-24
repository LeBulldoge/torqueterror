class_name BatUpgrade
extends Upgrade

var bat_scene = preload("res://weapons/bat.tscn")

@export var damage := 0.0
@export var attack_speed := 0.0
@export var scale := 0.0

enum BatWeaponSide { Left, Right }
@export var side: BatWeaponSide

@export var position := Vector2.ZERO
@export var sprite: Texture2D


func apply(player: Player):
    var bats := get_bats(player.get_node("Weapons").get_children())
    if position != Vector2.ZERO:
        var bat = bat_scene.instantiate()
        bat.position = position
        if side == BatWeaponSide.Left:
            bat.scale = Vector2(1, -1)
        else:
            bat.scale = Vector2(-1, -1)
        player.get_node("Weapons").add_child(bat)
        bats.append(bat)

    for bat in bats:
        bat.scale = (bat.scale / abs(bat.scale)) * scale
        bat.damage = damage
        bat.set_speed(attack_speed)
        if sprite != null:
            bat.set_sprite(sprite)

func get_bats(weapons: Array[Node]) -> Array[BatWeapon]:
    var bats: Array[BatWeapon] = []
    for weapon in weapons:
        if weapon is BatWeapon:
            bats.append(weapon)
    return bats
