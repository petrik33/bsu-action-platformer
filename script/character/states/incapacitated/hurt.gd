extends GameCharacterStateBase

@export var knockback_resist := 500


func enter():
	game_character.play_animation(&"hurt")
	game_character.velocity = game_character.last_hurt.knockback
	game_character.face(signf(-game_character.velocity.x))
	game_character.lock_movement()

func exit():
	game_character.unlock_movement()

func update_physics(delta: float):
	game_character.velocity.x = move_toward(
		game_character.velocity.x,
		0.0,
		knockback_resist * delta
	)

func post_physics() -> StringName:
	if is_zero_approx(game_character.velocity.x):
		return &"Idle"
	return &""
