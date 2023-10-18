extends Node


var ranged_enemy_scene = preload("res://enemy/ranged_enemy.tscn")
var melee_enemy_scene = preload("res://enemy/melee_enemy.tscn")


func _ready():
    start_game()

    $Map/Player.health.health_changed.connect($HUD.display_health)
    $Map/Player.health.death.connect(game_over)


func start_game():
    $SpawnTimer.start()


func game_over():
    $SpawnTimer.stop()


func get_point_outside_viewport() -> Vector2:
    $SpawnPath.position = $Map/Player.position
    $SpawnPath/SpawnPoint.progress_ratio = randf()

    return $SpawnPath/SpawnPoint.global_position


func setup_ranged_enemy() -> Enemy:
    var enemy = ranged_enemy_scene.instantiate()
    enemy.ai_modules.append(Attacker.new())
    enemy.ai_modules.append(Dasher.new())
    return enemy


func setup_melee_enemy() -> Enemy:
    var enemy = melee_enemy_scene.instantiate()
    enemy.ai_modules.append(Attacker.new())
    enemy.ai_modules.append(Chaser.new())
    return enemy


func _on_spawn_timer_timeout():
    var enemy = setup_ranged_enemy() if randi_range(0, 1) == 0 else setup_melee_enemy()

    enemy.target = $Map/Player
    enemy.global_position = get_point_outside_viewport()

    $Map.add_child(enemy)
