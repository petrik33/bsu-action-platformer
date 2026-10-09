@abstract
class_name CharacterLocomotionStateBase extends Node


var character: CharacterBody2D


func init(controlled_character: CharacterBody2D) -> void:
	character = controlled_character


func enter() -> void:
	pass

func exit() -> void:
	pass


@abstract func physics_update(delta: float) -> void
