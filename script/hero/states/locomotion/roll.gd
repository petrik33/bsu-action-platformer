extends HeroStateBase

@export var roll_speed: float = 300.0
@export var roll_duration: float = 0.5
@export var roll_animation: StringName = &"roll"
@export var invulnerable_during_roll: bool = true


func enter() -> void:
	var _roll_direction := hero.movement_direction
	if is_zero_approx(_roll_direction):
		_roll_direction = hero.facing_direction()
	
	steering.dash_vec(Vector2(_roll_direction * roll_speed, 0))
	
	if invulnerable_during_roll:
		hero.set_invulnerable(true)
	
	hero.play_animation(roll_animation)
	_state_timer(roll_duration, _on_finished)


func exit() -> void:
	if invulnerable_during_roll:
		hero.set_invulnerable(false)


func _on_finished() -> void:
	if character.is_on_floor():
		_transition(&"Idle")
	else:
		_transition(&"Fall")
