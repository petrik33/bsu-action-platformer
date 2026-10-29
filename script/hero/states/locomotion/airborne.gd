extends HeroStateBase

@export var attack_transition: StringName = &"Attack"


func update(delta: float) -> StringName:
	steering.apply(delta, hero.movement_direction * hero.base_speed * 0.5)

	if Input.is_action_just_pressed("jump") and hero.can_jump():
		return "Jump"
		
	if Input.is_action_just_pressed("click"):
		return attack_transition
		
	if Input.is_action_just_pressed("roll"):
		return "Roll"
		
	if hero.is_on_floor():
		return "Idle"
	
	return &""
