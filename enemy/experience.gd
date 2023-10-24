class_name Experience
extends Area2D

var experience: float = 1.0

var target: Player = null


func _ready():
    scale *= experience


func _process(_delta):
    if not target:
        return

    position += position.direction_to(target.position) * position.distance_to(target.position) * 0.05
