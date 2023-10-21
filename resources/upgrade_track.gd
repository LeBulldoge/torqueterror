class_name UpgradeTrack
extends Resource


@export var key: String
@export var upgrades: Array[Upgrade]

var _current := 0


func get_current() -> Upgrade:
    if upgrades.size() == 0:
        return null
    return upgrades[_current]


func next_level() -> bool:
    if _current == upgrades.size() - 1:
        return false
    _current += 1
    return true

