class_name Player
extends Vehicle


@export var velocity_damage_modifier = 0.0

signal shoot_projectile(projectile: Projectile)

@onready var health: HealthComponent = $HealthComponent

var proj_pierce := 0


func _ready():
    GameState.player = self


func _on_shoot_projectile(proj: Projectile):
    proj.pierce = proj_pierce
    shoot_projectile.emit(proj)


func _input(_event):
    var new_drive_dir = Input.get_axis("decelerate", "accelerate")
    self.steer_dir = Input.get_axis("steer_left", "steer_right")

    if new_drive_dir != self.drive_dir:
        switch_brake_lights(new_drive_dir < 0)

    self.drive_dir = new_drive_dir

    set_front_wheel_angle(self.steer_dir)
    switch_exhaust(self.drive_dir != 0)

    var zoom = Input.get_axis("zoom_in", "zoom_out")
    if zoom != 0:
        $Camera2D.zoom = lerp($Camera2D.zoom, $Camera2D.zoom - Vector2(zoom, zoom), abs(zoom) * 0.05)
        $Camera2D.zoom = clamp($Camera2D.zoom, Vector2(0.5, 0.5), Vector2(2, 2))


func _physics_process(delta):
    self.move_vehicle(delta)
    pitch_engine_sound()


func switch_brake_lights(value: bool):
    $BrakeLightLeft.enabled = value
    $BrakeLightRight.enabled = value


func set_front_wheel_angle(direction: float):
    $WheelFL.rotation_degrees = 25 * direction
    $WheelFR.rotation_degrees = 25 * direction


func switch_exhaust(value: bool):
    $Exhaust.emitting = value


func pitch_engine_sound():
    $EngineSound.pitch_scale = max(linear_velocity.length() / 200, 0.3)


func _on_hurt_box_component_area_entered(area: Area2D):
    if not area is HitBoxComponent:
        return

    var forward_velocity = linear_velocity.dot(transform.y)
    if forward_velocity <= 0:
        return

    var damage = forward_velocity * velocity_damage_modifier + 5
    var hb = area as HitBoxComponent
    hb.call_deferred("damage", damage)


func _on_hurt_box_component_rear_area_entered(area: Area2D):
    if not area is HitBoxComponent:
        return

    var forward_velocity = linear_velocity.dot(transform.y)
    if forward_velocity >= 0:
        return

    var damage = forward_velocity * velocity_damage_modifier + 5
    var hb = area as HitBoxComponent
    hb.call_deferred("damage", abs(damage))


func _on_gravity_funnel_area_entered(area: Area2D):
    if area is Experience:
        area.target = self


func _on_experience_component_area_entered(area: Area2D):
    if "experience" in area:
        GameState.add_experience(area.experience)
        area.queue_free()


func _on_hit_box_component_pos_damage_taken(damage: float, from: Vector2):
    apply_impulse(from.direction_to(global_position) * damage * 0.1, from)
    $PlayerHitSound.play()


func _on_is_drifting_changed(value):
    $WheelBL/Drift.emitting = value
    $WheelBR/Drift.emitting = value
