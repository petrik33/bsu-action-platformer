class_name Enemy extends Actor


@export var state_machine: CharacterStateMachine
@export var perception: EnemyPerception
@export var navigation: NavigationBase
@export var hurt_box: HurtBox
@export var alert_vfx: VfxBase
@export var steering: Steering
@export var gravity: Gravity
@export var resistance: Resistance
@export var patroling: Patroling
@export var kinematic: KinematicBase
@export var attack: EnemyAttack

var rng := RandomNumberGenerator.new()
var last_hurt: AttackData


func _ready() -> void:
	rng.seed = int(floorf(global_position.x - global_position.y))
	hurt_box.hit_received.connect(_on_hit_received)
	state_machine.initialize(self)

func _process(delta: float) -> void:
	state_machine.process(delta)

func _physics_process(delta: float) -> void:
	move_and_slide()
		
	if perception:
		perception.update(delta)
		
	if gravity:
		gravity.apply(delta)
		
	if resistance:
		resistance.apply(delta)
		
	state_machine.update(delta)
		
	if steering:
		steering.update(delta)

func can_attack(to_target: Vector2) -> bool:
	return attack.is_ready() and attack.in_distance(to_target)

func play_alert_vfx(time: float):
	alert_vfx.play(time)

func stop_alert_vfx():
	alert_vfx.stop()

func set_resistance(value: bool) -> void:
	if resistance:
		resistance.enabled = value

func hurt(payload: AttackData):
	last_hurt = payload
	state_machine.request_transition(&"Hurt")


func _on_hit_received(payload: AttackData):
	call_deferred(&"hurt", payload)
