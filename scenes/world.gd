class_name World
extends Node2D


func spawn(node: Node2D) -> void:
    $YSort/Map.add_child(node)
