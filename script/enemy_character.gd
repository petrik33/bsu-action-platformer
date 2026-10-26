class_name EnemyCharacter extends Actor


@export var state_machine: CharacterStateMachine
@export var perception: EnemyPerception
@export var navigation: EnemyNavigationBsae
@export var hurt_box: HurtBox
@export var hit_box: HitBox
@export var alert_vfx: AnimatedSprite2D

@export var gravity: float = 900
@export var gravity_enabled: bool = true

var last_hurt: AttackData


func _ready() -> void:
	super._ready()
	hurt_box.hit_received.connect(_on_hit_received)
	state_machine.initialize(self)

func _process(delta: float) -> void:
	state_machine.process(delta)

func _physics_process(delta: float) -> void:
	if gravity_enabled and not is_on_floor():
		velocity.y += gravity * delta

	state_machine.update_physics(delta)

	move_and_slide()

	state_machine.post_physics()

func play_alert_vfx(time: float):
	var anim_speed := Utils.get_sprite_animation_target_speed(alert_vfx, &"alert", time)
	alert_vfx.play(&"alert", anim_speed)

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
