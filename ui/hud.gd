class_name HUD
extends CanvasLayer


func _ready():
    var timeout = get_tree().create_timer(3).timeout
    timeout.connect($MessageLabel.hide)
    timeout.connect($FadePanel.hide)
    $AnimationPlayer.play("fade_in")


func _process(_delta):
    var elapsed = GameDirector.get_elapsed_time()
    $MarginContainer/Progress/GameTimer.text = "%d:%02d" % [(elapsed / 60), (int(elapsed) % 60)]
    $MarginContainer/Progress/GameProgress.value = GameDirector._get_normalized_elapsed_time()


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


func game_over(win: bool) -> Signal:
    var message: String = "[center]"
    if win:
        message += "You won!"
    else:
        message += "You lose!"
    message += "\n\nSurvived for " + $MarginContainer/Progress/GameTimer.text
    var label = $MessageLabel
    label.parse_bbcode(message)
    label.show()
    $FadePanel.show()
    var timeout = get_tree().create_timer(3).timeout
    timeout.connect(label.hide)
    timeout.connect($FadePanel.hide)
    $AnimationPlayer.play("fade_out")
    return timeout
