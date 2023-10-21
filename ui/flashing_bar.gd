class_name FlashingBar
extends ProgressBar


@export var flash_duration := 0.1
@export var flash_color := Color.WHITE

@onready var style = get("theme_override_styles/fill")
@onready var original_color = style.bg_color

var flash_tween: Tween


func _ready():
    assert(value_changed.is_connected(_on_value_changed), "Connect value changed")
    assert(style, "Fill style required")


func _on_value_changed(_value):
    if flash_tween:
        flash_tween.kill

    flash_tween = create_tween()
    flash_tween.tween_property(style, "bg_color", flash_color, flash_duration)
    flash_tween.tween_property(style, "bg_color", original_color, flash_duration)
