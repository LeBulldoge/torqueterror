extends Node


var ranged_enemy_scene = preload("res://enemy/ranged_enemy.tscn")
var melee_enemy_scene = preload("res://enemy/melee_enemy.tscn")
var swarm_enemy = preload("res://enemy/swarm.tscn")
var experience = preload("res://enemy/experience.tscn")


func _ready():
    $Map/Player/HealthComponent.health_changed.connect($HUD.display_health)
    $HUD.display_health($Map/Player/HealthComponent.MAX_HEALTH)
    $Map/Player/HealthComponent.death.connect(game_over)
    $Map/Player.shoot_projectile.connect(_on_spawn_projectile)

    GameState.score_changed.connect($HUD.display_score)
    GameState.experience_changed.connect($HUD.display_experience)

    GameState.level_changed.connect(_on_level_up)
    GameState.level_changed.connect($HUD.set_level)
    $HUD.set_level(GameState.level, GameState.get_level_requirement())

    GameDirector.game_timer_timeout.connect(game_over.bind(true))

    start_game()


func _on_level_up(_level: int, _new_max: float):
    get_tree().paused = true

    var upgrade = await choose_upgrade(3)
    if upgrade != null:
        upgrade.apply($Map/Player)

    get_tree().paused = false


func choose_upgrade(level: int) -> Upgrade:
    var upgrades = GameState.get_random_upgrades(level)
    if upgrades.is_empty():
        return

    for upgrade in upgrades:
        if upgrade is UpgradeTrack:
            upgrade = upgrade.get_current()
        $LevelUpScreen.add_upgrade_item(upgrade.title, upgrade.icon, upgrade.description)

    var chosen_upgrade_id = await $LevelUpScreen.choose_upgrade()
    var chosen_upgrade = upgrades[chosen_upgrade_id]

    var upgrade: Upgrade
    if chosen_upgrade is UpgradeTrack:
        upgrade = chosen_upgrade.get_current()
        if not chosen_upgrade.next_level():
            GameState.choose_upgrade(chosen_upgrade)
    else:
        upgrade = chosen_upgrade
        GameState.choose_upgrade(upgrade)

    return upgrade


func start_game():
    $HUD.show()
    GameDirector.start_game()
    $SpawnTimer.start()


func game_over(win: bool = false):
    GameDirector.stop_game()
    $SpawnTimer.stop()

    get_tree().paused = true
    await $HUD.game_over(win)
    get_tree().call_group("enemies", "queue_free")
    get_tree().change_scene_to_file("res://ui/main_menu.tscn")
    get_tree().paused = false

    GameState.reset()


func get_point_outside_viewport() -> Vector2:
    $SpawnPath.position = $Map/Player.position
    $SpawnPath/SpawnPoint.progress_ratio = randf()

    return $SpawnPath/SpawnPoint.global_position


func spawn_swarm():
    var spawn_point := get_point_outside_viewport()
    var swarm = swarm_enemy.instantiate()
    swarm.global_position = spawn_point

    for enemy in swarm.get_children():
        enemy.target = $Map/Player

        var death = enemy.get_node("HealthComponent").death
        death.connect(GameState.add_score.bind(0.2))
        death.connect(spawn_experience.bind(enemy))
    $Map.add_child(swarm)


func _on_spawn_timer_timeout():
    var num := randi_range(0, 5)
    if num == 5:
        spawn_swarm()
        return

    var enemy = ranged_enemy_scene.instantiate() if num <= 1 else melee_enemy_scene.instantiate()

    enemy.target = $Map/Player
    enemy.global_position = get_point_outside_viewport()

    $Map.add_child(enemy)
    enemy.weapon.shoot_projectile.connect(_on_spawn_projectile)
    var death = enemy.get_node("HealthComponent").death
    death.connect(GameState.add_score.bind(1))
    death.connect(spawn_experience.bind(enemy))


func _on_spawn_projectile(projectile: Projectile):
    $Map.call_deferred("add_child", projectile)


func spawn_experience(enemy: Enemy):
    var e = experience.instantiate()
    e.position = enemy.global_position
    e.experience = enemy.experience

    $Map.call_deferred("add_child", e)
