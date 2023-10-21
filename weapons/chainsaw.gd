class_name Chainsaw
extends Area2D


@export var damage := 1
@export var spin_speed := 1.0


func _ready():
    set_speed(spin_speed)


func set_speed(new_speed: float):
    $AnimationPlayer.speed_scale = new_speed


func _on_area_entered(area: Area2D):
    if not area is HitBoxComponent:
        return

    var hb = area as HitBoxComponent
    hb.damage(damage)
