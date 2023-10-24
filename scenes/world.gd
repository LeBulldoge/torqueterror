class_name World
extends Node2D


var bounds = Rect2(Vector2(-3200, -3200), Vector2(6464, 6464))


func spawn(node: Node2D) -> void:
    $YSort/Map.add_child(node)


func _process(delta):
    var pos = $YSort/Player.global_position
    if not bounds.has_point(pos):
        $YSort/Player/HitBoxComponent.damage(5 * delta)
