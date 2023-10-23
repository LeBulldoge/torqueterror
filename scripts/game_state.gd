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
    return (10 * (level - 1)) + (10 * level)


func add_score(value: int) -> void:
    score += value
    score_changed.emit(score)


@export var upgrade_pool: Array[Resource]
func get_random_upgrades(count: int) -> Array[Resource]:
    if upgrade_pool.is_empty():
        return []

    var results: Array[Resource] = []
    while count != 0 and results.size() < upgrade_pool.size():
        var idx = randi_range(0, upgrade_pool.size() - 1)
        if results.has(upgrade_pool[idx]):
            continue

        results.append(upgrade_pool[idx])
        count -= 1

    return results


func choose_upgrade(upgrade: Resource):
    upgrade_pool.remove_at(upgrade_pool.find(upgrade))
