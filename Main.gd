extends Node


var enemy_scene := preload("res://enemy/Enemy.tscn")


func _ready():
	start_game()
	
	$Player.health.death.connect(game_over)


func start_game():
	$SpawnTimer.start()


func game_over():
	$SpawnTimer.stop()


func _on_spawn_timer_timeout():
	var enemy := enemy_scene.instantiate() as Enemy
	
	enemy.target = $Player
	enemy.speed = 200
	enemy.damage = 1
	enemy.health = Health.new()
	enemy.health.max_health = 25

	add_child(enemy)
