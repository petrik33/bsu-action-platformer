extends GameCharacterStateBase


func post_physics() -> StringName:
	game_character.face_movement()
	return &""
