class_name CarDamageUpgrade
extends Upgrade


@export var modifier = 0.0


func apply(player: Player):
    player.velocity_damage_modifier = modifier
