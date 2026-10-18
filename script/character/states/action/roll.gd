extends GameCharacterStateBase

@export var speed: float = 500

func enter():
	game_character.play_animation("roll")
	game_character.animation_finished.connect(_on_animation_finished)
	var roll_direction := game_character.movement_direction
	if is_zero_approx(roll_direction):
		roll_direction = game_character.facing_direction()
	game_character.velocity.x = roll_direction * speed
	game_character.speed = roll_direction

func exit():
	game_character.reset_speed()
	game_character.animation_finished.disconnect(_on_animation_finished)

func _on_animation_finished():
	_transition(&"Idle")
