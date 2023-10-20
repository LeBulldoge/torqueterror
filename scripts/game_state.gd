extends Node


signal score_changed(score: int)
var score: int = 0

signal experience_changed(experience: float)
var experience: float = 0.0


func add_experience(value: float) -> void:
    experience += value
    experience_changed.emit(experience)


func add_score(value: int) -> void:
    score += value
    score_changed.emit(score)
