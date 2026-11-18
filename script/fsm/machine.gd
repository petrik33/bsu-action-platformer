class_name CharacterStateMachine extends Node


@export var initial: CharacterStateBase
@export var assert_on_unknown_state: bool


var states: Dictionary[StringName, CharacterStateBase] = {}
var active_path: Array[CharacterStateBase] = []

var _state_timers: Array[CharacterStateTimer] = []
var _state_elapsed: Dictionary[StringName, float] = {}

var _terminated := false


func is_active(state_name: StringName) -> bool:
	for state in active_path:
		if state.name == state_name:
			return true
	return false

func initialize(character: CharacterBody2D) -> void:
	_terminated = false
	for child in find_children("*", "CharacterStateBase"):
		var state = child as CharacterStateBase
		states[state.name] = state
		state.init(character, self)
		state.transition_requested.connect(_on_state_transition_requested)
		state.timer_requested.connect(
			func(time, callable): _on_state_timer_requested(state.name, time, callable)
		)
	if initial != null:
		transition_to(initial)

func terminate() -> void:
	if _terminated:
		return
	_terminated = true

	while active_path.size() > 0:
		var state_to_exit = active_path.pop_back()
		state_to_exit.exit()
		_remove_state_timers(state_to_exit.name)
		_state_elapsed.erase(state_to_exit.name)

	for state in states.values():
		state.terminate()

	_state_timers.clear()
	_state_elapsed.clear()

func process(delta: float) -> void:
	for state in active_path:
		state.process(delta)

func update(delta: float) -> void:
	_advance_state_time(delta)
	_progress_state_timers(delta)
	var state_requested := _evaluate_active_path_reverse(func(state: CharacterStateBase):
		return state.update(delta)
	)
	if not state_requested.is_empty():
		request_transition(state_requested)

func request_transition(target_state: StringName) -> void:
	if _terminated:
		return
	if not states.has(target_state):
		if assert_on_unknown_state:
			assert(false, "State " + target_state + " not registered")
		return
	transition_to(states[target_state])

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
		_remove_state_timers(state_to_exit.name)
		_state_elapsed.erase(state_to_exit.name)

	for i in range(lca_index, target_path.size()):
		var state_to_enter := target_path[i]
		active_path.append(state_to_enter)
		_state_elapsed[state_to_enter.name] = 0.0
		state_to_enter.enter()

func build_state_path(target: CharacterStateBase) -> Array[CharacterStateBase]:
	var result: Array[CharacterStateBase] = []
	var current: Node = target

	while current != self:
		if current is CharacterStateBase:
			result.push_front(current)
		current = current.get_parent()

	return result


func time_in_state(state_name: StringName) -> float:
	return _state_elapsed.get(state_name, 0.0)


func _advance_state_time(delta: float):
	for state in active_path:
		_state_elapsed[state.name] = _state_elapsed.get(state.name, 0.0) + delta


func _progress_state_timers(delta: float):
	var triggered: Array[CharacterStateTimer] = []
	for timer in _state_timers.duplicate():
		timer.remaining -= delta
		if timer.remaining > 0:
			continue
		timer.callback.call()
		triggered.push_back(timer)
	for timer in triggered:
		_state_timers.erase(timer)


func _remove_state_timers(state_name: StringName):
	for i in range(_state_timers.size() - 1, -1, -1):
		if _state_timers[i].state_name == state_name:
			_state_timers.remove_at(i)

func _on_state_transition_requested(state_name: StringName):
	call_deferred("request_transition", state_name)

func _on_state_timer_requested(state_name: StringName, time: float, callable: Callable):
	_state_timers.append(CharacterStateTimer.new(state_name, time, callable))

func _evaluate_active_path_reverse(action: Callable) -> StringName:
	for i in range(active_path.size() - 1, -1, -1):
		var requested: StringName = action.call(active_path[i])
		if requested != &"":
			return requested
	return &""
