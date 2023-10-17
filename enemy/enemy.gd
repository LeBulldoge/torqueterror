class_name Enemy
extends CharacterBody2D


@export var speed := 0
@export var damage := 0

var target: Node2D


func _ready():
	assert(target, "Enemy node requires a target")


func _process(delta):
	if target != null:
		look_at(target.global_position)


func _physics_process(delta):
	var collision = move_and_collide(velocity)
	if collision:
		if collision.get_collider().has_method("hit"):
			velocity = velocity.bounce(collision.get_normal())
			collision.get_collider().hit(damage)

	velocity = lerp(velocity, transform.x * speed * delta, 1 * delta)
