class_name Weapon
extends Area2D

enum WeaponType { Melee, Ranged }

@export var damage := 0
@export var type: WeaponType
@export var attack_cooldown = 1

@onready var attack_timer: Timer = $AttackTimer


func _ready():
    attack_timer.wait_time = attack_cooldown


func start_attack(target: HitBoxComponent):
    var target_health = target.health_component

    attack_timer.timeout.connect(attack.bind(target, target_health))
    attack_timer.start()


func stop_attack():
    attack_timer.stop()
    attack_timer.timeout.disconnect(attack)


func attack(target: Node2D, health: HealthComponent):
    if type == WeaponType.Ranged:
        shoot(target.global_position)
    else:
        apply_damage(health)


func apply_damage(health: HealthComponent):
    health.damage(damage)

var projectile_scene = preload("res://scenes/projectile.tscn")
signal shoot_projectile(projectile: Projectile)
func shoot(target: Vector2) -> void:
    var proj = projectile_scene.instantiate() as Projectile
    proj.position = global_position
    proj.speed = 200
    proj.direction = global_position.direction_to(target)
    proj.look_at(target)

    proj.area_entered.connect(_on_projectile_hit.bind(proj))
    shoot_projectile.emit(proj)


func _on_projectile_hit(body: Area2D, projectile: Projectile) -> void:
    if not body is HitBoxComponent:
        print("Detected wrong body type " + body.to_string())
        return

    var hitbox = body as HitBoxComponent
    apply_damage(hitbox.health_component)
    projectile.queue_free()
