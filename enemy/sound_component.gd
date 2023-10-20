class_name SoundComponent
extends AudioStreamPlayer2D


@export var sounds: Dictionary


func _ready():
    pass


func play_random_sound(category: String):
    if not category in sounds:
        print("SoundComponent: Attempted to play nonexistent category")
        return

    var sc = sounds[category] as Array[AudioStreamWAV]

    stream = sc[randi() % sc.size()]
    play()
