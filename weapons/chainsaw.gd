class_name Chainsaw
extends Area2D


@export var damage := 1.0
@export var attack_speed := 1.0


func _ready():
    set_speed(attack_speed)


func set_sprite(sprite: Texture2D):
    var animation = $AnimatedSprite2D.animation
    var frames = $AnimatedSprite2D.sprite_frames as SpriteFrames
    for id in frames.get_frame_count($AnimatedSprite2D.animation):
        var texture := frames.get_frame_texture(animation, id)
        texture.atlas = sprite
        frames.set_frame(animation, id, texture)


func set_speed(new_speed: float):
    $AnimationPlayer.speed_scale = new_speed


func _on_area_entered(area: Area2D):
    if not area is HitBoxComponent:
        return

    var hb = area as HitBoxComponent
    hb.damage(damage)


func _on_chain_area_entered(area):
    if not area is HitBoxComponent:
        return

    var hb = area as HitBoxComponent
    hb.damage(damage * 0.2)
