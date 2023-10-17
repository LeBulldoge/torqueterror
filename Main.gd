extends Node


var enemy_scene := preload("res://enemy/Enemy.tscn")


func _on_spawn_timer_timeout():
	var enemy := enemy_scene.instantiate() as Enemy
	
	enemy.target = $Player
	enemy.speed = 200
	enemy.damage = 5

	add_child(enemy)
