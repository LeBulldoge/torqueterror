class_name HUD
extends CanvasLayer


func display_health(health: int):
    $MarginContainer/Health/HealthBar.value = health


func set_health_max(new_max: int):
    $MarginContainer/Health/HealthBar.max_value = new_max


func display_score(score: int):
    $MarginContainer/Score.text = str(score)


func set_level(level: int, new_max: float):
    $MarginContainer/Experience/Label.text = "Level " + str(level)
    set_experience_max(new_max)
    set_experience_min($MarginContainer/Experience/ProgressBar.value)

func display_experience(experience: float):
    $MarginContainer/Experience/ProgressBar.value = experience

func set_experience_max(new_max: float):
    $MarginContainer/Experience/ProgressBar.max_value = new_max


func set_experience_min(new_min: float):
    $MarginContainer/Experience/ProgressBar.min_value = new_min
