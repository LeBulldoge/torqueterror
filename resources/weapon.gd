class_name Weapon
extends Resource

enum WeaponType { Melee, Ranged }

@export var damage := 0
@export var type: WeaponType
@export var range := 0
@export var attack_cooldown = 1

var attack_timer = Timer.new()

func _init(new_damage: int = 0, new_type: WeaponType = WeaponType.Melee):
	damage = new_damage
	type = new_type

	match type:
		WeaponType.Melee: range = 50
		WeaponType.Ranged: range = 200
	attack_timer.wait_time = attack_cooldown
	attack_timer.one_shot = true


func attack(health: Health):
	attack_timer.start()
	health.take_damage(damage)

	return attack_timer.timeout

func is_attack_on_cooldown():
	return not attack_timer.is_stopped()
