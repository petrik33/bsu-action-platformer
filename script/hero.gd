class_name Hero extends Actor


@export var state_machine: CharacterStateMachine
@export var hit_box: HitBox
@export var hurt_box: HurtBox
@export var steering: Steering
@export var gravity: Gravity
@export var resistance: Resistance
@export var move_behavior: HorizontalVelocityMatch
@export var kinematic: KinematicGrounded
@export var gun: Gun
@export var dash_trail: OnionSkinTrail

@export var base_speed: float = 400
@export var jump_speed: float = 350

var jumps_left := 2
var movement_direction := 0.0
var last_hurt: AttackData


func _ready() -> void:
	super._ready()
	state_machine.initialize(self)
	hurt_box.hit_received.connect(_on_hit_received)

func _process(delta: float) -> void:
	state_machine.process(delta)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"resurrect"):
		resurrect()

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if is_on_floor():
		jumps_left = 2
	
	movement_direction = signf(Input.get_axis("left", "right"))
		
	if gravity:
		gravity.apply(delta)
		
	if resistance:
		resistance.apply(delta)
		
	state_machine.update(delta)
		
	if steering:
		steering.update(delta)

func _exit_tree() -> void:
	state_machine.terminate()

func move_horizontally(speed_multiplier: float = 1.0):
	move_behavior.velocity = movement_direction * base_speed * speed_multiplier
	steering.use(move_behavior)

func hurt(attack_data: AttackData):
	last_hurt = attack_data
	if health:
		if not health.take_damage(attack_data.damage):
			return
		if health.is_dead():
			return
	state_machine.request_transition(&"Hurt")

func on_death() -> void:
	if hurt_box:
		hurt_box.is_invulnerable = true
	if state_machine:
		state_machine.request_transition(&"Death")

func resurrect() -> bool:
	if health == null or not health.is_dead():
		return false

	health.reset()
	if hurt_box:
		hurt_box.is_invulnerable = false
	if state_machine:
		state_machine.request_transition(&"Idle")
	return true

func set_resistance(value: bool) -> void:
	if resistance:
		resistance.enabled = value

func set_invulnerable(value: bool) -> void:
	if hurt_box:
		hurt_box.is_invulnerable = value

func is_invulnerable() -> bool:
	return hurt_box != null and hurt_box.is_invulnerable

func can_jump() -> bool:
	return jumps_left > 0

func jump():
	jumps_left -= 1
	velocity.y = -jump_speed

func can_aim() -> bool:
	return gun != null and not gun.is_holstered


func start_dash_trail() -> void:
	if dash_trail:
		dash_trail.start()


func stop_dash_trail() -> void:
	if dash_trail:
		dash_trail.stop()


func _on_hit_received(attack_data: AttackData):
	call_deferred(&"hurt", attack_data)
