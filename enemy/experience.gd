extends RigidBody2D

var experience: float = 1.0

func _ready():
    scale *= experience
