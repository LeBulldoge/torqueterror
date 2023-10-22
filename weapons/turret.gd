class_name TurretWeapon
extends Area2D

@export var damage := 1.0
@export var attack_range: float :
    set(value):
        $AttackRadius.shape.radius = value
    get:
        return $AttackRadius.shape.radius

@export var attack_speed: float :
    set(value):
        $Timer.wait_time = value
    get:
        return $Timer.wait_time

var targets: Array[HitBoxComponent] = []
var current_target: HitBoxComponent


func _ready():
    $AttackRadius.shape.radius = attack_range
    $Timer.wait_time = attack_speed


func _on_area_entered(body: Area2D):
    if not body is HitBoxComponent:
        print(self, ":wrong body type detected", body)
        return
    var enemy := body as HitBoxComponent

    if targets.has(enemy):
        return

    targets.append(enemy)
    if $Timer.is_stopped():
        $Timer.start()


func _on_area_exited(body: Area2D):
    if not body is HitBoxComponent:
        print(self, ":wrong body type detected", body)
        return
    var enemy := body as HitBoxComponent

    var idx = targets.find(enemy)
    if idx == -1:
        return

    targets.remove_at(idx)


func get_distance_to_target(target: HitBoxComponent) -> float:
    return target.global_position.distance_to(global_position)


func _on_timer_timeout():
    if targets.is_empty():
        $Timer.stop()
        return

    current_target = null

    var target: HitBoxComponent = targets[0]
    var min_distance := get_distance_to_target(targets[0])
    for t in targets:
        var new_distance := get_distance_to_target(target)
        if new_distance < min_distance:
            target = t
            min_distance = new_distance

    current_target = target
    $Gun.look_at(target.global_position)
    $Gun.rotation_degrees += 90
    shoot(target.global_position)


var projectile_scene = preload("res://scenes/player_projectile.tscn")
signal shoot_projectile(projectile: Projectile)
func shoot(target: Vector2) -> void:
    var proj = projectile_scene.instantiate() as Projectile
    proj.position = global_position
    proj.speed = 200
    proj.direction = global_position.direction_to(target)
    proj.look_at(target)

    proj.damage = damage

    shoot_projectile.emit(proj)
    #get_parent().get_parent().get_parent().add_child(proj)

