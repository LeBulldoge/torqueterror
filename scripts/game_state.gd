extends Node


signal score_changed(score: int)
var score: int = 0

signal experience_changed(experience: float)
var experience: float = 0.0

signal level_changed(level: int, new_max: float)
var level: int = 1


func reset():
    score = 0
    experience = 0.0
    level = 1


func _level_up() -> void:
    level += 1
    level_changed.emit(level, get_level_requirement())


func add_experience(value: float) -> void:
    experience += value
    experience_changed.emit(experience)
    if experience >= get_level_requirement():
        _level_up()


func get_level_requirement() -> float:
    return pow(4.0, level) + 10.0


func add_score(value: int) -> void:
    score += value
    score_changed.emit(score)


@export var upgrade_pool: Array[Upgrade]
func get_random_upgrades(count: int) -> Array[Upgrade]:
    var results: Array[Upgrade] = []
    while count != 0:
        var idx = randi_range(0, upgrade_pool.size() - 1)
        if results.has(upgrade_pool[idx]):
            continue

        results.append(upgrade_pool[idx])
        count -= 1

    return results


