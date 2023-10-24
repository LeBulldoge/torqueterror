class_name EGameDirector
extends Node


@export var difficulty_curve: Curve

# Game length, in seconds
@export var game_length: float = 1.0
@onready var game_timer := $GameTimer

var event_point := 1

signal game_timer_timeout
signal event_point_reached

func _ready():
    game_timer.wait_time = game_length


func _process(_delta):
    if game_timer.is_stopped() or event_point >= difficulty_curve.point_count:
        return
    if _get_normalized_elapsed_time() >= difficulty_curve.get_point_position(event_point).x:
        print("Event point reached: ", event_point)
        event_point_reached.emit()
        event_point += 1


func start_game() -> void:
    game_timer.start()


func stop_game() -> void:
    game_timer.stop()


func _normalize_value(value: float, vmin: float, vmax: float) -> float:
    return (value - vmin) / (vmax - vmin)


func _get_normalized_elapsed_time() -> float:
    return _normalize_value(get_elapsed_time(), 0.0, game_timer.wait_time)


func get_difficulty_value() -> float:
    var normalized_time = _get_normalized_elapsed_time()
    var sample = difficulty_curve.sample(normalized_time)
    return sample


func get_elapsed_time() -> float:
    return game_timer.wait_time - game_timer.time_left


func _on_game_timer_timeout():
    game_timer_timeout.emit()
