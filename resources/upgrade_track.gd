class_name UpgradeTrack
extends Resource


@export var key: String
@export var upgrades: Array[Upgrade]

var _current := 0


func get_current() -> Upgrade:
    return upgrades[_current]


func next_level() -> bool:
    if _current == upgrades.size():
        return false
    _current += 1
    return true

