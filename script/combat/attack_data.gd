class_name AttackData extends RefCounted


var damage: float = 10.0
var knockback: Vector2 = Vector2.ZERO
var hitstun: float = 0.2
var attacker: Node2D


func _init(pDamage: float, pKnockback: Vector2, pAttacker: Node2D, pHitstun: float = 0.2) -> void:
	damage = pDamage
	knockback = pKnockback
	attacker = pAttacker
	hitstun = pHitstun
