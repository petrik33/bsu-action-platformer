extends CharacterStateBase

@export var speed: float = 500

func enter():
	character.play_animation("roll")
	character.animation_finished.connect(_on_animation_finished)
	var roll_direction := character.movement_direction
	if is_zero_approx(roll_direction):
		roll_direction = character.facing_direction()
	character.velocity.x = roll_direction * speed
	character.speed = roll_direction

func exit():
	character.reset_speed()
	character.animation_finished.disconnect(_on_animation_finished)

func _on_animation_finished(_anim_name: StringName):
	_transition("idle")
