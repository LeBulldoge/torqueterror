class_name Player
extends Vehicle


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	self.drive_dir = Input.get_axis("decelerate", "accelerate")
	self.steer_dir = Input.get_axis("steer_left", "steer_right")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	move_vehicle(delta)
