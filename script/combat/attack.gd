class_name Attack extends Node

@export var hit_box: HitBox
@export var payload: AttackPayload

var _is_active: bool = false
var _targets_hit: Array[HurtBox] = []


func _ready() -> void:
	hit_box.hit.connect(_on_hit_box_hit)

func start():
	if is_active():
		return
	_is_active = true

func end():
	_targets_hit.clear()
	_is_active = false

func is_active() -> bool:
	return _is_active

func _on_hit_box_hit(hurt_box: HurtBox):
	if not _is_active:
		return
	if _targets_hit.has(hurt_box):
		return
	var diff = hurt_box.global_position.x - hit_box.global_position.x
	var direction = Vector2(signf(diff), -payload.knockback_y).normalized()
	var attack := AttackData.new(payload, owner, direction)
	if hurt_box.take_hit(attack):
		_targets_hit.append(hurt_box)
