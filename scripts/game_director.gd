class_name EGameDirector
extends Node


@export var difficulty_curve: Curve

# Game length, in seconds
@export var game_length: float = 1.0
@onready var game_timer := $GameTimer

var event_point := 1

signal game_timer_timeout
signal event_point_reached

func _ready():
    game_timer.wait_time = game_length


func _process(_delta):
    if game_timer.is_stopped() or event_point >= difficulty_curve.point_count:
        return
    if _get_normalized_elapsed_time() >= difficulty_curve.get_point_position(event_point).x:
        print("Event point reached: ", event_point)
        event_point_reached.emit()
        event_point += 1


func start_game() -> void:
    game_timer.start()
    $SpawnTimer.start()


func stop_game() -> void:
    game_timer.stop()
    $SpawnTimer.stop()

func _normalize_value(value: float, vmin: float, vmax: float) -> float:
    return (value - vmin) / (vmax - vmin)


func _get_normalized_elapsed_time() -> float:
    return _normalize_value(get_elapsed_time(), 0.0, game_timer.wait_time)


func get_difficulty_value() -> float:
    var normalized_time = _get_normalized_elapsed_time()
    var sample = difficulty_curve.sample(normalized_time)
    return sample


func get_elapsed_time() -> float:
    return game_timer.wait_time - game_timer.time_left


func _on_game_timer_timeout():
    game_timer_timeout.emit()


var ranged_enemy_scene = preload("res://enemy/ranged_enemy.tscn")
var melee_enemy_scene = preload("res://enemy/melee_enemy.tscn")
var swarm_enemy = preload("res://enemy/swarm.tscn")
var experience = preload("res://enemy/experience.tscn")
var melee_boss_scene := preload("res://enemy/melee_enemy_boss.tscn")


func spawn_experience(enemy: Enemy):
    var e = experience.instantiate()
    e.position = enemy.global_position
    e.experience = enemy.experience
    spawn_projectile(e)


func spawn_swarm():
    var swarm = swarm_enemy.instantiate()

    for enemy in swarm.get_children():
        enemy.target = GameState.player
        var death = enemy.get_node("HealthComponent").death
        death.connect(GameState.add_score.bind(1))
        death.connect(spawn_experience.bind(enemy))

    spawn(swarm)

func _spawn_boss():
    var enemy := melee_boss_scene.instantiate()

    enemy.target = GameState.player

    spawn(enemy)
    await enemy.ready

    enemy.weapon.shoot_projectile.connect(spawn_projectile)
    var death = enemy.get_node("HealthComponent").death
    death.connect(GameState.add_score.bind(10))
    death.connect(spawn_experience.bind(enemy))


func _on_spawn_timer_timeout():
    var num := randi_range(0, 9)
    if num == 5:
        spawn_swarm()
        return

    var enemy: Enemy
    if num <= 3:
        enemy = ranged_enemy_scene.instantiate()
    else:
        enemy = melee_enemy_scene.instantiate()

    enemy.target = GameState.player
    spawn(enemy)
    await enemy.ready
    enemy.weapon.shoot_projectile.connect(spawn_projectile)
    var death = enemy.get_node("HealthComponent").death
    death.connect(GameState.add_score.bind(1))
    death.connect(spawn_experience.bind(enemy))


signal spawn_requested(node: Node, position_required: bool)
func spawn(node: Node):
    spawn_requested.emit(node, true)


func spawn_projectile(projectile: Projectile):
    spawn_requested.emit(projectile, false)


func _on_event_point_reached():
    _spawn_boss()
    $SpawnTimer.wait_time *= 0.8
