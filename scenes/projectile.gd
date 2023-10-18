class_name Projectile
extends Area2D


var direction := Vector2.ZERO
var speed := 0.0


func _ready():
    pass


func _process(delta):
    position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
    queue_free()
