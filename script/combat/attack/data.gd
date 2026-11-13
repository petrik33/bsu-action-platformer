class_name AttackData extends RefCounted


var damage: float = 10.0
var knockback: Vector2 = Vector2.ZERO
var hitstun: float = 0.2
var attacker: Node2D


func _init(payload: AttackPayload, owner: Node2D, direction: Vector2) -> void:
	damage = payload.damage
	knockback = direction * payload.knockback_force
	attacker = owner
	hitstun = payload.hitstun
