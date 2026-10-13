class_name CharacterStateMachine extends Node


@export var initial: CharacterStateBase
@export var assert_on_unknown_state: bool


var states: Dictionary[StringName, CharacterStateBase] = {}
var active_path: Array[CharacterStateBase] = []


func initialize(character: GameCharacter):
	for child in find_children("*", "CharacterStateBase"):
		var state = child as CharacterStateBase
		states[state.name] = state
		state.character = character
		state.transition_requested.connect(_on_transition_requested)
	if initial != null:
		transition_to(initial)

func handle_input() -> void:
	var state_requested := _evaluate_active_path_reverse(func(state: CharacterStateBase):
		return state.handle_input()
	)
	if not state_requested.is_empty():
		_on_transition_requested(state_requested)

func update_physics(delta: float) -> void:
	for state in active_path:
		state.update_physics(delta)

func post_physics() -> void:
	var state_requested := _evaluate_active_path_reverse(func(state: CharacterStateBase):
		return state.post_physics()
	)
	if not state_requested.is_empty():
		_on_transition_requested(state_requested)

func transition_to(target_state: CharacterStateBase) -> void:
	if target_state == null:
		return

	var target_path := build_state_path(target_state)
	
	var lca_index := 0
	var min_length := mini(active_path.size(), target_path.size())
	
	while lca_index < min_length and active_path[lca_index] == target_path[lca_index]:
		if active_path[lca_index] == target_state:
			break
		lca_index += 1

	while active_path.size() > lca_index:
		var state_to_exit = active_path.pop_back()
		state_to_exit.exit()

	for i in range(lca_index, target_path.size()):
		var state_to_enter := target_path[i]
		active_path.append(state_to_enter)
		state_to_enter.enter()

func build_state_path(target: CharacterStateBase) -> Array[CharacterStateBase]:
	var result: Array[CharacterStateBase] = []
	var current: Node = target

	while current != self:
		if current is CharacterStateBase:
			result.push_front(current)
		current = current.get_parent()

	return result


func _evaluate_active_path_reverse(action: Callable) -> StringName:
	for i in range(active_path.size() - 1, -1, -1):
		var requested: StringName = action.call(active_path[i])
		if requested != &"":
			return requested
	return &""

func _on_transition_requested(to: StringName):
	if not states.has(to):
		if assert_on_unknown_state:
			assert(false, "State " + to + " not registered")
		return
	transition_to(states[to])
