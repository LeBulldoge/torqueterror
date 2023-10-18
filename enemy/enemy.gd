class_name Enemy
extends CharacterBody2D

@export var speed := 0

var target: Node2D

enum State { Free, Moving, Attacking }
var state: State = State.Free
signal state_changed(new_state)

@onready var ai_module_group = str(get_instance_id()) + "_ai_modules"
@onready var weapon = $WeaponComponent as Weapon

func _ready():
    assert(target, "Enemy node requires a target")

    add_to_group("enemies")

    $HealthBar.max_value = $HealthComponent.MAX_HEALTH
    $HealthComponent.health_changed.connect(display_health)
    $HealthComponent.death.connect(queue_free)

    for module in $AIModules.get_children():
        module.add_to_group(ai_module_group)
        module.setup(self)


func display_health(value):
    $HealthBar.value = value


func set_state(new_state: State) -> void:
    if state == new_state:
        return

    self.state = new_state
    state_changed.emit(self.state)


func _process(_delta):
    get_tree().call_group(ai_module_group, "perform", self)
