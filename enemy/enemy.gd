class_name Enemy
extends CharacterBody2D

@export var speed := 0
@export var experience := 0.0

var target: Node2D

enum State { Free = 0, Moving, Attacking }
var state: State = State.Free
signal state_changed(new_state)

@onready var ai_module_group = str(get_instance_id()) + "_ai_modules"
@onready var weapon = $WeaponComponent as Weapon
@onready var sprite = $AnimatedSprite2D as AnimatedSprite2D
@export var animation: AnimationPlayer


func _ready():
    assert(target, "Enemy node requires a target")

    add_to_group("enemies")
    apply_difficulty()

    $HealthBar.max_value = $HealthComponent.MAX_HEALTH
    $HealthBar.value = $HealthComponent.MAX_HEALTH
    $HealthComponent.health_changed.connect(display_health)
    $HealthComponent.death.connect(death)

    for module in $AIModules.get_children():
        module.add_to_group(ai_module_group)
        module.setup(self)


func apply_difficulty():
    var difficulty: float = GameDirector.get_difficulty_value()
    $HealthComponent.MAX_HEALTH = $HealthComponent.MAX_HEALTH * difficulty
    $WeaponComponent.damage = $WeaponComponent.damage * difficulty
    experience = experience * difficulty

func display_health(value):
    $HealthBar.value = value
    $DamageIndicator.play()
    $SoundComponent.play_random_sound("damage")


func death():
    process_mode = Node.PROCESS_MODE_DISABLED
    $SoundComponent.play_random_sound("death")
    await $DamageIndicator.animation_finished
    queue_free()


func set_state(new_state: State) -> void:
    if state == new_state:
        return

    self.state = new_state
    state_changed.emit(self.state)


func _process(_delta):
    get_tree().call_group(ai_module_group, "perform", self)


func _physics_process(_delta):
    get_tree().call_group(ai_module_group, "perform_physics", self)

    # Currently the sprites we use face in one direction
    # flip them based on the direction they're walking
    if sprite == null:
        return
    var dir = position.direction_to(target.position).dot(transform.x)
    sprite.flip_h = dir > 0


func _on_state_changed(new_state):
    if sprite == null:
        return

    if new_state == Enemy.State.Attacking:
        if sprite.sprite_frames.has_animation("attack"):
            sprite.play("attack")
    else:
        sprite.play("default")
        if animation and animation.has_animation("enemies/idle"):
            animation.play("enemies/idle")


func _on_weapon_component_attacked():
    if animation and animation.has_animation("enemies/attack"):
        animation.stop()
        animation.play("enemies/attack")
