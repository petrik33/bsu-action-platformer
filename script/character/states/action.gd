extends GameCharacterStateBase


func process(_delta: float) -> StringName:
	game_character.face_movement()
	return &""


func update(_delta: float) -> StringName:
	if Input.is_action_just_pressed("jump") and game_character.can_jump():
		return "Jump"

	return &""
