class_name Weapon
extends Resource

enum WeaponType { Melee, Ranged }

@export var damage := 0
@export var type: WeaponType
@export var attack_range := 0
@export var attack_cooldown = 1

var attack_timer = Timer.new()

func _init(new_damage: int = 0, new_type: WeaponType = WeaponType.Melee):
    damage = new_damage
    type = new_type

    match type:
        WeaponType.Melee: attack_range = 50
        WeaponType.Ranged: attack_range = 200
    attack_timer.wait_time = attack_cooldown
    attack_timer.one_shot = true


func attack(health: HealthComponent):
    attack_timer.start()
    health.damage(damage)

    return attack_timer.timeout

func is_attack_on_cooldown():
    return not attack_timer.is_stopped()
