class_name Projectile
extends Area2D


var damage := 0.0
var direction := Vector2.ZERO
var speed := 0.0
var pierce := 0.0
var bounce := 0.0


func _ready():
    pass


func _process(delta):
    position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
    queue_free()


func _on_area_entered(area: Area2D) -> void:
    if not area is HitBoxComponent:
        print("Detected wrong area type " + area.to_string())
        return

    var hitbox = area as HitBoxComponent
    hitbox.positional_damage(damage, global_position)
    if pierce > 0:
        pierce -= 1
    else:
        queue_free()
