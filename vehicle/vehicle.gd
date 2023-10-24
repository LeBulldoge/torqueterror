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

signal is_drifting_changed(value: bool)
var is_drifting := false
@export var slip_speed := 40.0
@export var traction_slow = 4.0
@export var traction_fast = 1.0


func set_drifting(value: bool):
    if is_drifting == value:
        return
    is_drifting = value
    is_drifting_changed.emit(value)

func move_vehicle(_delta):
    var forward = transform.y
    var right = transform.x

    if drive_dir == 0 and linear_velocity.length() < stall_speed:
        linear_velocity = Vector2.ZERO
    else:
        # Acceleration
        apply_central_force(drive_dir * forward * speed)

    # Drag
    apply_central_force(-drag * linear_velocity)

    # Cancel out lateral force
    var lateral_velocity = right.dot(linear_velocity) * right

    # Drift
    var traction = traction_slow
    if lateral_velocity.length() > slip_speed:
        traction = traction_fast
        set_drifting(true)
    else:
        set_drifting(false)

    apply_central_force(-lateral_velocity * traction * tire_grip)

    # Turn
    if steer_dir != 0:
        var torque_force = steer_dir * torque * sqrt(linear_velocity.length())
        if linear_velocity.dot(forward) < 0:
            torque_force = -torque_force
        apply_torque(torque_force)
