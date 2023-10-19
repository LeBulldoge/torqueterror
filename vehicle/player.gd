class_name Player
extends Vehicle


func _input(_event):
    var new_drive_dir = Input.get_axis("decelerate", "accelerate")
    self.steer_dir = Input.get_axis("steer_left", "steer_right")

    if new_drive_dir != self.drive_dir:
        switch_brake_lights(new_drive_dir < 0)

    self.drive_dir = new_drive_dir


func _physics_process(delta):
    self.move_vehicle(delta)


func switch_brake_lights(value: bool):
    $BrakeLightLeft.enabled = value
    $BrakeLightRight.enabled = value
