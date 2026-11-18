class_name Projectile extends Node2D

signal hit_target(hurt_box: HurtBox, point: Vector2, normal: Vector2)
signal hit_wall(point: Vector2)
signal expired

@export var lifetime: float = 2.0
@export var piercing: bool = false
@export var payload: AttackPayload
@export var wall_collision_area: Area2D
@export var shape_cast: HitShapeCast

var direction: Vector2 = Vector2.RIGHT
var shooter: Node2D
var speed: float

var _launched: bool = false
var _life: float = 0.0
var _hit_targets: Array[HurtBox] = []


func _ready() -> void:
	wall_collision_area.body_entered.connect(_on_wall_collision)

func _exit_tree() -> void:
	wall_collision_area.body_entered.disconnect(_on_wall_collision)

func _physics_process(delta: float) -> void:
	if not _launched:
		return

	_life -= delta
	if _life <= 0.0:
		expired.emit()
		queue_free()
		return

	var step := direction * speed * delta
	if step.is_zero_approx():
		return

	move_to(global_position + step)


func shoot(from: Vector2, pDirection: Vector2, pShooter: Node2D, pSpeed: float) -> void:
	global_position = from
	direction = pDirection.normalized()
	shooter = pShooter
	speed = pSpeed
	_life = lifetime
	_launched = true

func move_to(point: Vector2) -> void:
	var hits := shape_cast.sweep(point)
	if _resolve_collisions(hits):
		return

	global_position = point


func _resolve_collisions(hits: Array[Dictionary]) -> bool:
	for hit in hits:
		var collider: Object = hit["collider"]

		if not collider is HurtBox:
			continue

		var hurt_box := collider as HurtBox

		if _hit_targets.has(hurt_box):
			continue
		if not _apply_damage(hurt_box):
			continue

		var point: Vector2 = hit["point"]
		var normal: Vector2 = hit["normal"]

		_hit_targets.append(hurt_box)
		hit_target.emit(hurt_box, point, normal)

		if not piercing:
			_stop_at(point)
			return true

	return false

func _on_wall_collision(_body: Node2D):
	hit_wall.emit(wall_collision_area.global_position)
	queue_free()

func _apply_damage(hurt_box: HurtBox) -> bool:
	if payload == null:
		return false
	var attacker := shooter if is_instance_valid(shooter) else null
	var attack := AttackData.new(payload, attacker, direction)
	return hurt_box.take_hit(attack)

func _stop_at(point: Vector2) -> void:
	global_position = point
	queue_free()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if shape_cast == null and get_node_or_null(^"ShapeCast2D") == null:
		warnings.append("Projectile requires a HitShapeCast child or an assigned shape_cast.")
	if payload == null:
		warnings.append("Projectile has no AttackPayload and will not damage HurtBoxes.")
	return warnings
