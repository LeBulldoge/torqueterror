class_name Enemy
extends CharacterBody2D


@export var health: Health
@export var speed := 0
@export var damage := 0

var target: Node2D


func _ready():
	assert(target, "Enemy node requires a target")
	health.reset()


func _process(delta):
	if target != null:
		look_at(target.global_position)
	else:
		rotate(deg_to_rad(5))


func _physics_process(delta):
	if target == null:
		return
	
	var collision = move_and_collide(velocity)
	if collision:
		if "health" in collision.get_collider():
			var h = collision.get_collider().health as Health
			h.take_damage(damage)
			
			var bounce_ratio = (h.max_health / health.max_health) * 0.2
			velocity = velocity.bounce(collision.get_normal()) * bounce_ratio
		else:
			velocity = velocity.direction_to(transform.x)

	velocity = lerp(velocity, transform.x * speed * delta, 1 * delta)
