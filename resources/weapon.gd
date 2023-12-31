class_name Weapon
extends Area2D

enum WeaponType { Melee, Ranged }

@export var damage := 0.0
@export var type: WeaponType
@export var attack_cooldown := 1.0

@onready var attack_timer: Timer = $AttackTimer
signal attacked()

func _ready():
    attack_timer.wait_time = attack_cooldown


func start_attack(target: HitBoxComponent):
    attack_timer.timeout.connect(attack.bind(target))
    attack_timer.start()


func stop_attack():
    attack_timer.stop()
    attack_timer.timeout.disconnect(attack)


func attack(target: HitBoxComponent):
    if type == WeaponType.Ranged:
        shoot(target.global_position)
    else:
        target.positional_damage(damage, global_position)
    attacked.emit()

func apply_damage(health: HealthComponent):
    health.damage(damage)


var projectile_scene = preload("res://scenes/projectile.tscn")
signal shoot_projectile(projectile: Projectile)
func shoot(target: Vector2) -> void:
    var proj = projectile_scene.instantiate() as Projectile
    proj.position = global_position
    proj.speed = 200
    proj.direction = global_position.direction_to(target)
    proj.damage = damage
    proj.look_at(target)

    shoot_projectile.emit(proj)
