class_name BatWeapon
extends Area2D


@export var damage := 1.0
@export var attack_speed := 1.0


func _ready():
    set_speed(attack_speed)


func set_speed(new_speed: float):
    $AnimationPlayer.speed_scale = new_speed
    $AnimatedSprite2D.speed_scale = new_speed


func set_sprite(new_sprite: Texture2D):
    var frames: SpriteFrames = $AnimatedSprite2D.sprite_frames
    frames.clear("default")

    var atlas0 = AtlasTexture.new()
    atlas0.atlas = new_sprite
    atlas0.region = Rect2(0, 0, 53, 57)
    frames.add_frame("default", atlas0)

    var atlas1 = AtlasTexture.new()
    atlas1.atlas = new_sprite
    atlas1.region = Rect2(53, 0, 53, 57)
    frames.add_frame("default", atlas1)

func _on_area_entered(area: Area2D):
    if not area is HitBoxComponent:
        return

    var hb = area as HitBoxComponent
    hb.damage(damage)
