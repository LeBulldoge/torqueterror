class_name Player
extends Vehicle


@export var velocity_damage_modifier = 5.0


func _input(_event):
    var new_drive_dir = Input.get_axis("decelerate", "accelerate")
    self.steer_dir = Input.get_axis("steer_left", "steer_right")

    if new_drive_dir != self.drive_dir:
        switch_brake_lights(new_drive_dir < 0)

    self.drive_dir = new_drive_dir

    set_front_wheel_angle(self.steer_dir)


func _physics_process(delta):
    self.move_vehicle(delta)


func switch_brake_lights(value: bool):
    $BrakeLightLeft.enabled = value
    $BrakeLightRight.enabled = value


func set_front_wheel_angle(direction: float):
    $WheelFL.rotation_degrees = 25 * direction
    $WheelFR.rotation_degrees = 25 * direction


func _on_hurt_box_component_area_entered(area: Area2D):
    if not area is HitBoxComponent:
        return

    var forward_velocity = linear_velocity.dot(transform.y)
    if forward_velocity <= 0:
        return

    var damage = forward_velocity * velocity_damage_modifier
    var hb = area as HitBoxComponent
    hb.damage(damage)
