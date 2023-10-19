extends PointLight2D

@export var fog_scroll_speed = 1.0

@onready var noise = self.texture.noise as FastNoiseLite

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    noise.offset.x += fog_scroll_speed * delta
    noise.offset.y += fog_scroll_speed * delta
