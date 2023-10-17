class_name Player
extends Vehicle

@export var health: Health

func _ready():
	health.reset()
	health.death.connect(queue_free)


func _input(event):
	self.drive_dir = Input.get_axis("decelerate", "accelerate")
	self.steer_dir = Input.get_axis("steer_left", "steer_right")


func _physics_process(delta):
	self.move_vehicle(delta)
