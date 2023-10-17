extends Node


var enemy_scene := preload("res://enemy/Enemy.tscn")


func _ready():
	start_game()

	$Player.health.health_changed.connect($HUD.display_health)
	$Player.health.death.connect(game_over)



func start_game():
	$SpawnTimer.start()


func game_over():
	$SpawnTimer.stop()


func get_point_outside_viewport() -> Vector2:
	var result := Vector2.ZERO

	$SpawnPath.position = $Player.position
	$SpawnPath/SpawnPoint.progress_ratio = randf()

	return $SpawnPath/SpawnPoint.global_position


func _on_spawn_timer_timeout():
	var enemy := enemy_scene.instantiate() as Enemy

	enemy.target = $Player
	enemy.speed = 200
	enemy.damage = 1
	enemy.health = Health.new(25)

	enemy.global_position = get_point_outside_viewport()

	add_child(enemy)
