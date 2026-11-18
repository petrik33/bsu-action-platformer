class_name CharacterStateBase extends Node


signal transition_requested(to: StringName)
signal timer_requested(time: float, callable: Callable)


var character: CharacterBody2D
var machine: CharacterStateMachine


func init(owner_character: CharacterBody2D, owner_machine: CharacterStateMachine):
	character = owner_character
	machine = owner_machine

func enter():
	pass

func exit():
	pass

func terminate():
	pass

func process(delta: float) -> void:
	pass

func update(delta: float) -> StringName:
	return &""

func time_in_state() -> float:
	return machine.time_in_state(name)

func _transition(to: StringName):
	transition_requested.emit(to)

func _state_timer(time: float, callable: Callable):
	timer_requested.emit(time, callable)

func _schedule_transition(time: float, to: StringName):
	_state_timer(time, func(): _transition(to))

func _call_after(time: float, callable: Callable):
	var elapsed := time_in_state()
	if elapsed >= time:
		callable.call()
		return
	_state_timer(time - elapsed, callable)

func _transition_after(time: float, to: StringName):
	_call_after(time, func(): _transition(to))
