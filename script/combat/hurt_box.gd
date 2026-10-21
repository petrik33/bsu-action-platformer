class_name HurtBox extends Area2D


signal hit_received(attack: AttackData)

@export var is_invulnerable: bool = false

func take_hit(attack: AttackData) -> bool:
	if is_invulnerable:
		return false
	hit_received.emit(attack)
	return true
