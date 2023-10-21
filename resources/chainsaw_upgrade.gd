class_name ChainsawUpgrade
extends Upgrade

var chainsaw_scene = preload("res://weapons/chainsaw.tscn")

@export var damage := 0.0
@export var spin_speed := 0.0
@export var scale = 0.0

@export var sprite: Texture2D


func apply(player: Player):
    var chainsaw := get_chainsaw(player.get_node("Weapons").get_children())
    if chainsaw == null:
        chainsaw = chainsaw_scene.instantiate()
        player.get_node("Weapons").add_child(chainsaw)

    chainsaw.scale = Vector2(scale, scale)
    chainsaw.damage = damage
    chainsaw.set_speed(spin_speed)
    if sprite != null:
        chainsaw.set_sprite(sprite)


func get_chainsaw(weapons: Array[Node]) -> Chainsaw:
    for weapon in weapons:
        if weapon is Chainsaw:
            return weapon
    return null
