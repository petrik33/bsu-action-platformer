class_name HitBox extends Area2D

signal hit(hurt_box: HurtBox)

@export var damage: float = 15.0
@export var knockback_force: float = 200.0
@export var hitstun: float = 0.2

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HurtBox:
		var direction := Vector2.RIGHT.rotated(global_rotation)
		if owner is Node2D:
			var diff = area.global_position.x - owner.global_position.x
			direction = Vector2(signf(diff), -0.5).normalized()

		var attack := AttackData.new(damage, direction * knockback_force, owner, hitstun)
		if area.take_hit(attack):
			hit.emit(area)
