class_name GameCharacter extends Actor


@export var state_machine: CharacterStateMachine
@export var hit_box: HitBox

@export var speed: float = 400
@export var gravity: float = 900
@export var gravity_enabled: bool = true
@export var default_speed: float = 400
@export var jump_speed: float = 350


var jumps_left := 2
var movement_direction := 0.0


func _ready() -> void:
	super._ready()
	state_machine.initialize(self)


func _process(delta: float) -> void:
	state_machine.process(delta)


func _physics_process(delta: float) -> void:
	movement_direction = signf(Input.get_axis("left", "right"))
	
	state_machine.update_physics(delta)
	
	if not is_on_floor():
		velocity.y += float(gravity_enabled) * get_gravity().y * delta
	else:
		jumps_left = 2
	
	velocity.x = movement_direction * speed
	
	move_and_slide()
	
	state_machine.post_physics()


func can_jump() -> bool:
	return jumps_left > 0

func jump():
	jumps_left -= 1
	velocity.y = -jump_speed

func reset_speed():
	speed = default_speed
