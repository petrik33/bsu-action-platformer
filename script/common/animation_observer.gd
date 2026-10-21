class_name AnimationObserver extends Node

signal frame_entered
signal frame_exited

@export var sprite: AnimatedSprite2D
@export var animation: StringName

## Target frame index (0-based). Supports negative values: 
## -1 means the last frame, -2 means the second-to-last frame, etc.
@export var frame: int = 0

var _is_currently_active: bool = false

func _ready() -> void:
	if not sprite:
		return
	
	_resolve_frame_index()
	if sprite.animation == animation:
		sprite.frame_changed.connect(_on_frame_changed)
	sprite.animation_changed.connect(_on_animation_changed)

func _on_frame_changed() -> void:
	var matches_condition := (sprite.frame == frame)
	
	if matches_condition and not _is_currently_active:
		_is_currently_active = true
		frame_entered.emit()
	elif not matches_condition and _is_currently_active:
		_is_currently_active = false
		frame_exited.emit()

func _on_animation_changed() -> void:
	if sprite.animation == animation:
		if not sprite.frame_changed.is_connected(_on_frame_changed):
			sprite.frame_changed.connect(_on_frame_changed)
	elif sprite.frame_changed.is_connected(_on_frame_changed):
		sprite.frame_changed.disconnect(_on_frame_changed)
		if _is_currently_active:
			_is_currently_active = false
			frame_exited.emit()

## Resolves frame so negative indices (-1, -2) map correctly to frame positions.
func _resolve_frame_index():
	if frame >= 0:
		return

	if not sprite.sprite_frames or not sprite.sprite_frames.has_animation(animation):
		return

	var total_frames: int = sprite.sprite_frames.get_frame_count(animation)
	frame = total_frames + frame

func _get_configuration_warnings() -> PackedStringArray:
	if sprite == null:
		return ["Target sprite not set"]
	if animation == "":
		return ["Animation not set"]
	if not sprite.sprite_frames.has_animation(animation):
		return ["No such animation in target sprite"]
	return []

func _on_frame_entered():
	pass

func _on_frame_exited():
	pass
