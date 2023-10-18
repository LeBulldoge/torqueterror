class_name HitBoxComponent
extends Area2D

@export var health_component: HealthComponent

func damage(value: float):
    if health_component:
        health_component.damage(value)
