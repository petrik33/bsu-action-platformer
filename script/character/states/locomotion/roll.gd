extends GameCharacterStateBase

@export var roll_speed: float = 300.0
@export var roll_duration: float = 0.5
@export var roll_animation: StringName = &"roll"
@export var invulnerable_during_roll: bool = true


func enter() -> void:
	var _roll_direction := game_character.movement_direction
	if is_zero_approx(_roll_direction):
		_roll_direction = game_character.facing_direction()
	
	game_character.velocity.x = _roll_direction * roll_speed
	game_character.lock_movement()
	
	if invulnerable_during_roll:
		game_character.set_invulnerable(true)
	
	game_character.play_animation(roll_animation)
	_state_timer(roll_duration, _on_finished)


func exit() -> void:
	if invulnerable_during_roll:
		game_character.set_invulnerable(false)
	
	game_character.unlock_movement()


func _on_finished() -> void:
	if character.is_on_floor():
		_transition(&"Idle")
	else:
		_transition(&"Fall")
