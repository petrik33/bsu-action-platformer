class_name OnionSkinTrail
extends Node2D

@export var source: AnimatedSprite2D
@export var shader: Shader = preload("res://shader/onion_skin.gdshader")
@export var material_template: ShaderMaterial

@export_group("Emission")
@export var spawn_interval: float = 0.035
@export var lifetime: float = 0.22
@export var max_ghosts: int = 16

@export_group("Look")
@export var tint: Color = Color(0.35, 0.75, 1.0, 1.0)
@export var fade_tint: Color = Color(0.10, 0.25, 0.85, 1.0)
@export var base_alpha: float = 0.55
@export_range(0.0, 1.0) var color_mix: float = 0.0
@export_range(0.0, 1.0) var gradient_strength: float = 0.35
@export_range(0.0, 1.0) var flicker: float = 0.12
@export_range(0.0, 1.0) var dissolve: float = 0.0
@export var fade_curve: Curve

var _emitting := false
var _spawn_timer := 0.0
var _ghosts: Array[Ghost] = []
var _pool: Array[Ghost] = []


class Ghost:
	var sprite: Sprite2D
	var material: ShaderMaterial
	var age: float = 0.0
	var lifetime: float = 0.2


func _ready() -> void:
	if material_template == null and shader != null:
		material_template = ShaderMaterial.new()
		material_template.shader = shader
	set_process(false)


func _process(delta: float) -> void:
	if _emitting:
		_spawn_timer -= delta
		var interval := maxf(spawn_interval, 0.001)
		while _spawn_timer <= 0.0:
			_spawn_timer += interval
			_spawn()

	_update_ghosts(delta)

	if not _emitting and _ghosts.is_empty():
		set_process(false)


func start() -> void:
	_emitting = true
	_spawn_timer = 0.0
	set_process(true)


func stop() -> void:
	_emitting = false


func set_emitting(value: bool) -> void:
	if value:
		start()
	else:
		stop()


func is_emitting() -> bool:
	return _emitting


func clear() -> void:
	for ghost in _ghosts:
		_release(ghost)
	_ghosts.clear()
	if not _emitting:
		set_process(false)


func _spawn() -> void:
	if max_ghosts <= 0:
		return

	var texture := _frame_texture()
	if texture == null:
		return

	if _ghosts.size() >= max_ghosts:
		var oldest: Ghost = _ghosts.pop_front()
		_release(oldest)

	var ghost := _acquire()
	var sprite := ghost.sprite
	sprite.texture = texture
	sprite.centered = source.centered
	sprite.offset = source.offset
	sprite.flip_h = source.flip_h
	sprite.flip_v = source.flip_v
	sprite.global_transform = source.global_transform
	sprite.visible = true

	ghost.age = 0.0
	ghost.lifetime = maxf(lifetime, 0.001)
	_apply_look(ghost)
	_apply_fade(ghost, 1.0)
	_ghosts.append(ghost)


func _acquire() -> Ghost:
	if not _pool.is_empty():
		var reused: Ghost = _pool.pop_back()
		reused.sprite.visible = true
		return reused

	var sprite := Sprite2D.new()
	sprite.top_level = true
	if material_template != null:
		sprite.material = material_template.duplicate() as ShaderMaterial
	add_child(sprite)

	var ghost := Ghost.new()
	ghost.sprite = sprite
	ghost.material = sprite.material as ShaderMaterial
	return ghost


func _release(ghost: Ghost) -> void:
	ghost.sprite.visible = false
	_pool.append(ghost)


func _update_ghosts(delta: float) -> void:
	for i in range(_ghosts.size() - 1, -1, -1):
		var ghost := _ghosts[i]
		ghost.age += delta
		var t := ghost.age / ghost.lifetime
		if t >= 1.0:
			_release(ghost)
			_ghosts.remove_at(i)
			continue
		_apply_fade(ghost, _fade_at(t))


func _fade_at(t: float) -> float:
	if fade_curve != null:
		return clampf(fade_curve.sample(t), 0.0, 1.0)
	return 1.0 - t


func _apply_look(ghost: Ghost) -> void:
	if ghost.material == null:
		return
	ghost.material.set_shader_parameter("tint", tint)
	ghost.material.set_shader_parameter("fade_tint", fade_tint)
	ghost.material.set_shader_parameter("alpha", base_alpha)
	ghost.material.set_shader_parameter("color_mix", color_mix)
	ghost.material.set_shader_parameter("gradient_strength", gradient_strength)
	ghost.material.set_shader_parameter("flicker", flicker)
	ghost.material.set_shader_parameter("dissolve", dissolve)


func _apply_fade(ghost: Ghost, fade: float) -> void:
	if ghost.material == null:
		return
	ghost.material.set_shader_parameter("fade", fade)


func _frame_texture() -> Texture2D:
	if source == null or source.sprite_frames == null:
		return null
	if not source.sprite_frames.has_animation(source.animation):
		return null
	var frame_count := source.sprite_frames.get_frame_count(source.animation)
	if source.frame < 0 or source.frame >= frame_count:
		return null
	return source.sprite_frames.get_frame_texture(source.animation, source.frame)
