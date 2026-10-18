class_name HurtBox extends Area2D


signal hit_received(attack: AttackData)

@export var is_invulnerable: bool = false

var last_hit: AttackData

func take_hit(attack: AttackData) -> bool:
	if is_invulnerable:
		return false
	last_hit = attack
	hit_received.emit(attack)
	return true
