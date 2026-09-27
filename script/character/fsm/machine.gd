class_name CharacterStateMachine extends Node


@export var registered: Dictionary[StringName, CharacterStateBase]
@export var initial: CharacterStateBase


var state: CharacterStateBase


func initialize(character: Character):
	for key in registered:
		registered[key].character = character
	_change_state(initial)


func handle_input() -> void:
	if state == null:
		return
	var state_requested := state.handle_input()
	if not state_requested.is_empty():
		_on_transition_requested(state_requested)


func update() -> void:
	if state == null:
		return
	var state_requested := state.update()
	if not state_requested.is_empty():
		_on_transition_requested(state_requested)


func _on_transition_requested(to: StringName):
	assert(registered.has(to), "State " + to + " not registered")
	var next_state := registered[to]
	_change_state(next_state)


func _change_state(next_state: CharacterStateBase):
	if state != null:
		state.exit(next_state)
		state.transition_requested.disconnect(_on_transition_requested)
		
	var from := state 
	state = next_state
	
	if next_state != null:
		next_state.transition_requested.connect(_on_transition_requested)
		next_state.enter(from)
