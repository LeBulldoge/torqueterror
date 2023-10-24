class_name StatUpgrade
extends Upgrade


@export var stats: Dictionary


func apply(player: Player):
    for k in stats.keys():
        player[k] = stats.get(k)
