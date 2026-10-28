class_name CharacterStateBase extends Node


signal transition_requested(to: StringName)
signal timer_requested(time: float, callable: Callable)


var character: CharacterBody2D


func init(owner_character: CharacterBody2D):
	character = owner_character

func enter():
	pass

func exit():
	pass

func process(delta: float) -> void:
	pass

func update(delta: float) -> StringName:
	return &""

func _transition(to: StringName):
	transition_requested.emit(to)

func _state_timer(time: float, callable: Callable):
	timer_requested.emit(time, callable)
