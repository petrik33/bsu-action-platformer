class_name HealthComponent extends Node


signal health_changed(current: float, maximum: float)
signal damaged(amount: float, current: float, maximum: float)
signal healed(amount: float, current: float, maximum: float)
signal died


@export var max_hp: float = 100.0

var current_hp: float = 0.0


func _ready() -> void:
	reset()


func reset() -> void:
	current_hp = max_hp
	health_changed.emit(current_hp, max_hp)


func take_damage(amount: float) -> bool:
	if amount <= 0.0 or is_dead():
		return false

	var previous := current_hp
	current_hp = maxf(current_hp - amount, 0.0)
	damaged.emit(previous - current_hp, current_hp, max_hp)
	health_changed.emit(current_hp, max_hp)

	if is_dead():
		died.emit()

	return true


func heal(amount: float) -> bool:
	if amount <= 0.0 or is_dead():
		return false

	var previous := current_hp
	current_hp = minf(current_hp + amount, max_hp)
	if is_equal_approx(previous, current_hp):
		return false

	healed.emit(current_hp - previous, current_hp, max_hp)
	health_changed.emit(current_hp, max_hp)
	return true


func kill() -> void:
	if is_dead():
		return

	var amount := current_hp
	current_hp = 0.0
	damaged.emit(amount, current_hp, max_hp)
	health_changed.emit(current_hp, max_hp)
	died.emit()


func set_max_hp(value: float, refill: bool = false) -> void:
	max_hp = maxf(value, 0.0)
	current_hp = max_hp if refill else minf(current_hp, max_hp)
	health_changed.emit(current_hp, max_hp)


func is_dead() -> bool:
	return current_hp <= 0.0


func get_ratio() -> float:
	if max_hp <= 0.0:
		return 0.0
	return current_hp / max_hp
