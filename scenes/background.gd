extends TextureRect


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    rotation += 0.05 * delta
