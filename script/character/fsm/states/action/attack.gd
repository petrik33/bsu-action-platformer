class_name CharacterStateAttack extends CharacterStateBase


@export var lock_speed: float = 50


func enter():
	character.animation_finished.connect(_on_animation_finished)
	character.play_animation("attack")
	character.speed = lock_speed

func exit():
	character.reset_speed()
	character.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished(_anim_name: StringName):
	_transition("idle")
