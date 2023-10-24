extends Node


func _ready():
    var health: HealthComponent = GameState.player.health
    health.health_changed.connect($HUD.display_health)
    health.max_health_changed.connect($HUD.set_health_max)
    $HUD.display_health(health.MAX_HEALTH)

    $World/YSort/Player/HealthComponent.death.connect(game_over)
    $World/YSort/Player.shoot_projectile.connect(_on_spawn_requested)

    GameState.score_changed.connect($HUD.display_score)
    GameState.experience_changed.connect($HUD.display_experience)

    GameState.level_changed.connect(_on_level_up)
    GameState.level_changed.connect($HUD.set_level)
    $HUD.set_level(GameState.level, GameState.get_level_requirement())

    GameDirector.game_timer_timeout.connect(game_over.bind(true))
    GameDirector.spawn_requested.connect(_on_spawn_requested)
    start_game()

    await _on_level_up(0, 0)


func _on_spawn_requested(node: Node2D, position_requested: bool = false):
    if position_requested:
        node.global_position = get_point_outside_viewport()
    $World.spawn(node)


func _on_level_up(level: int, _new_max: float):
    get_tree().paused = true

    var upgrade = await choose_upgrade(3)
    if upgrade != null:
        upgrade.apply(GameState.player)

    if level > 0:
        GameState.player.health.increase_health(GameState.get_health_upgrade(level))

    get_tree().paused = false


func choose_upgrade(level: int) -> Upgrade:
    if $LevelUpScreen.visible:
        await $LevelUpScreen.visibility_changed

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


func game_over(win: bool = false):
    GameDirector.stop_game()

    get_tree().paused = true
    await $HUD.game_over(win)
    get_tree().call_group("enemies", "queue_free")
    get_tree().change_scene_to_file("res://ui/main_menu.tscn")
    get_tree().paused = false

    GameState.reset()


func get_point_outside_viewport() -> Vector2:
    $SpawnPath.position = $World/YSort/Player.position
    $SpawnPath/SpawnPoint.progress_ratio = randf()

    return $SpawnPath/SpawnPoint.global_position
