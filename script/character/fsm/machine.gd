class_name CharacterStateMachine extends Node


@export var initial: CharacterStateBase


var states: Dictionary[StringName, CharacterStateBase] = {}
var active_path: Array[CharacterStateBase] = []


func initialize(character: GameCharacter):
	for child in find_children("*", "CharacterStateBase"):
		var state = child as CharacterStateBase
		states[state.name] = state
		state.character = character
	transition_to(initial)


func handle_input() -> void:
	for state in active_path:
		var state_requested := state.handle_input()
		if not state_requested.is_empty():
			_on_transition_requested(state_requested)
			return

func update_physics(delta: float) -> void:
	for state in active_path:
		state.update_physics(delta)

func post_physics() -> void:
	for state in active_path:
		var state_requested := state.post_physics()
		if not state_requested.is_empty():
			_on_transition_requested(state_requested)
			return

func transition_to(next_state: CharacterStateBase):
	if state != null:
		state.exit()
		state.transition_requested.disconnect(_on_transition_requested)
		
	state = next_state
	
	if next_state != null:
		next_state.transition_requested.connect(_on_transition_requested)
		next_state.enter()

func build_state_path(target: CharacterStateBase) -> Array[CharacterStateBase]:
	var result: Array[CharacterStateBase] = []
	var current: Node = target

	while current != self:
		if current is CharacterStateBase:
			result.push_front(current)
		current = current.get_parent()

	return result


func _on_transition_requested(to: StringName):
	assert(states.has(to), "State " + to + " not registered")
	transition_to(states[to])
