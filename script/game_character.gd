class_name GameCharacter extends Actor


@export var state_machine: CharacterStateMachine
@export var hit_box: HitBox
@export var hurt_box: HurtBox

@export var speed: float = 400
@export var gravity: float = 900
@export var gravity_enabled: bool = true
@export var default_speed: float = 400
@export var jump_speed: float = 350


var jumps_left := 2
var movement_direction := 0.0
var is_movement_locked := false
var last_hurt: AttackData

func _ready() -> void:
	state_machine.initialize(self)
	hurt_box.hit_received.connect(_on_hit_received)


func _process(delta: float) -> void:
	state_machine.process(delta)


func _physics_process(delta: float) -> void:
	movement_direction = signf(Input.get_axis("left", "right"))

	if not is_on_floor():
		velocity.y += float(gravity_enabled) * get_gravity().y * delta
	else:
		jumps_left = 2

	state_machine.update(delta)

	if not is_movement_locked:
		velocity.x = movement_direction * speed

	move_and_slide()

func hurt(attack_data: AttackData):
	last_hurt = attack_data
	state_machine.request_transition(&"Hurt")

func set_invulnerable(value: bool) -> void:
	if hurt_box:
		hurt_box.is_invulnerable = value

func is_invulnerable() -> bool:
	return hurt_box != null and hurt_box.is_invulnerable

func lock_movement():
	is_movement_locked = true

func unlock_movement():
	is_movement_locked = false

func can_jump() -> bool:
	return jumps_left > 0

func jump():
	jumps_left -= 1
	velocity.y = -jump_speed

func reset_speed():
	speed = default_speed


func _on_hit_received(attack_data: AttackData):
	call_deferred(&"hurt", attack_data)
