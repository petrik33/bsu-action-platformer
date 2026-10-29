extends HeroStateBase


func process(_delta: float):
	hero.face_movement()


func update(_delta: float) -> StringName:
	if Input.is_action_just_pressed("jump") and hero.can_jump():
		return "Jump"

	return &""
