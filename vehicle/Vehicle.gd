class_name Vehicle
extends RigidBody2D

@export var speed := 0
@export var top_speed := 0
@export var stall_speed := 0
@export var torque := 0
@export var tire_grip := 0.0
@export var drag := 0.0

var drive_dir := 0.0
var steer_dir := 0.0

func move_vehicle(_delta):
    var forward = transform.y
    var right = transform.x

    if drive_dir == 0 and linear_velocity.length() < stall_speed:
        linear_velocity = Vector2.ZERO

    # Acceleration
    apply_central_force(drive_dir * forward * speed)

    # Drag
    apply_central_force(-drag * linear_velocity)

    # Cancel out lateral force
    var lateral_velocity = right.dot(linear_velocity) * right
    apply_central_force(-lateral_velocity * tire_grip)

    # Turn
    apply_torque(steer_dir * torque * sqrt(linear_velocity.length()))
