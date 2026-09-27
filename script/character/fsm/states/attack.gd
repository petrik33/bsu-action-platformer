class_name CharacterStateAttack extends CharacterStateBase


@export var speed: float = 300.0


func enter(from: CharacterStateBase):
	character.animation_finished.connect(_on_animation_finished)
	character.play_animation("attack")


func exit(to: CharacterStateBase):
	character.animation_finished.disconnect(_on_animation_finished)


func update_physics(delta: float) -> StringName:
	var direction := Input.get_axis("left", "right")
	
	character.update_horizontal_velocity(speed, direction)
	
	if direction != 0:
		character.flip(direction)
		
	return ""


func _on_animation_finished(anim_name: StringName):
	_transition("idle")
