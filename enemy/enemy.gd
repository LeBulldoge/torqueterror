class_name Enemy
extends CharacterBody2D


@export var health: Health
@export var weapon: Weapon

@export var ai_modules: Array[AIModule]
@export var speed := 0

var target: Node2D


func _ready():
    assert(target, "Enemy node requires a target")

    $HealthBar.max_value = health.max_health
    health.health_changed.connect(display_health)
    health.death.connect(queue_free)
    health.reset()

    add_child(weapon.attack_timer)


func display_health(health):
    $HealthBar.value = health


func _process(delta):
    for module in ai_modules:
        module.perform(self)


#func _physics_process(delta):
#	var collision = move_and_collide(velocity)
#	if collision:
#		var obj = collision.get_collider()
#		if not obj.is_in_group("enemies") and "health" in obj:
#			var h = obj.health as Health
#			weapon.attack(health)
#
#			var bounce_ratio = (h.max_health / health.max_health) * 0.2
#			velocity = velocity.bounce(collision.get_normal()) * bounce_ratio
#		else:
#			velocity = velocity.direction_to(transform.x)
#
#	velocity = lerp(velocity, transform.x * speed * delta, 1 * delta)
