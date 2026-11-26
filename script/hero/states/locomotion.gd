extends HeroStateBase

@export var attack_state: StringName = &"Attack"
@export var air_attack_state: StringName = &"AirAttack"


func process(_delta: float) -> void:
	hero.face_movement()

func update(_delta: float) -> StringName:
	if Input.is_action_just_pressed("jump") and hero.can_jump():
		return &"Jump"
		
	if Input.is_action_just_pressed("click"):
		if not hero.is_on_floor() and machine.states.has(air_attack_state):
			return air_attack_state
		return attack_state
		
	if Input.is_action_just_pressed("roll"):
		return &"Roll"
	
	if Input.is_action_pressed("aim") and gun != null:
		return &"UseGun"
	
	return &""
