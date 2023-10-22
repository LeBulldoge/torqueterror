class_name HitBoxComponent
extends Area2D

@export var health_component: HealthComponent

func damage(value: float):
    if health_component:
        health_component.damage(value)


signal pos_damage_taken(damage: float, from: Vector2)
func positional_damage(value: float, from: Vector2):
    if health_component:
        health_component.damage(value)
        pos_damage_taken.emit(value, from)
