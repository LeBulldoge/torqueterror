class_name BatWeapon
extends Area2D


@export var damage := 1.0
@export var attack_speed := 1.0


func _ready():
    set_speed(attack_speed)


func set_speed(new_speed: float):
    $AnimationPlayer.speed_scale = new_speed
    $AnimatedSprite2D.speed_scale = new_speed


func _on_area_entered(area: Area2D):
    if not area is HitBoxComponent:
        return

    var hb = area as HitBoxComponent
    hb.damage(damage)
