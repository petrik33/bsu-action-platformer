class_name Enemy extends Actor


@export var state_machine: CharacterStateMachine
@export var perception: EnemyPerception
@export var navigation: EnemyNavigationBsae
@export var hurt_box: HurtBox
@export var hit_box: HitBox
@export var alert_vfx: VfxBase
@export var steering: Steering
@export var gravity: Gravity

var last_hurt: AttackData


func _ready() -> void:
	hurt_box.hit_received.connect(_on_hit_received)
	state_machine.initialize(self)

func _process(delta: float) -> void:
	state_machine.process(delta)

	func _physics_process(delta: float) -> void:
	if gravity:
		gravity.apply(delta)
	
	state_machine.update(delta)
	
	move_and_slide()
	
	if perception:
		perception.update(delta)

func play_alert_vfx(time: float):
	alert_vfx.play(time)

func stop_alert_vfx():
	alert_vfx.stop()

func hurt(attack: AttackData):
	last_hurt = attack
	state_machine.request_transition(&"Hurt")

func move_horizontal(direction: float, speed: float):
	velocity.x = sign(direction) * speed

func stop_horizontal() -> void:
	velocity.x = 0.0


func _on_hit_received(attack: AttackData):
	call_deferred(&"hurt", attack)
