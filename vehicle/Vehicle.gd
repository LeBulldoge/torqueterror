class_name Vehicle
extends RigidBody2D

@export var speed := 0
@export var top_speed := 0
@export var torque := 0

var drive_dir := 0.0
var steer_dir := 0.0

func move_vehicle(delta):
    var forward = transform.y
    var right = transform.x

    apply_central_force(drive_dir * forward * speed)

    var lateral_velocity = right.dot(linear_velocity) * right
    apply_central_force(-lateral_velocity)

    apply_torque(steer_dir * torque * sqrt(linear_velocity.length()))
