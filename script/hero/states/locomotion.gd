extends HeroStateBase

@export var attack_state: StringName = &"Attack"


func process(_delta: float) -> void:
	hero.face_movement()

func update(_delta: float) -> StringName:
	if Input.is_action_just_pressed("jump") and hero.can_jump():
		return &"Jump"
		
	if Input.is_action_just_pressed("click"):
		return attack_state
		
	if Input.is_action_just_pressed("roll"):
		return &"Roll"
	
	if Input.is_action_pressed("shoot"):
		return &"StartAim"
	
	return &""
