class_name CameraRig extends Camera2D

## Presentation-layer camera controller.
##
## Gameplay states never touch the camera directly. They emit intent signals on
## the Hero (`aim_started`, `aim_ended`, `shot_fired`) and this rig turns that
## intent into camera motion. All effects are layered on top of the follow
## transform:
## - aim: smooth zoom + look-ahead offset
## - shot: trauma-based shake + short zoom punch
##
## Shake uses the "trauma" model: trauma decays linearly and the actual shake is
## trauma^2, so small hits stay subtle and big hits feel strong. Noise is sampled
## from FastNoiseLite instead of random per-frame values to avoid jitter and to
## stay frame-rate independent.

@export_group("Target")
@export var target: Hero

@export_group("Aim")
@export var aim_zoom: Vector2 = Vector2(2.2, 2.2)
@export var aim_offset: Vector2 = Vector2(28.0, -6.0)
@export var aim_blend_speed: float = 8.0
@export var aim_turn_speed: float = 10.0

@export_group("Shake")
@export var shake_decay: float = 2.5
@export var shake_max_offset: Vector2 = Vector2(10.0, 6.0)
@export var shake_max_rotation: float = 0.03
@export var shake_noise_speed: float = 40.0
@export var shot_zoom_punch: float = 0.05
@export var zoom_punch_decay: float = 8.0

@export_group("Debug")
@export var fly_speed: float = 600.0

var _base_position: Vector2
var _base_offset: Vector2
var _base_zoom: Vector2

var _aiming: bool = false
var _aim_blend: float = 0.0
var _aim_direction: float = 1.0
var _aim_offset: Vector2
var _trauma: float = 0.0
var _zoom_punch: float = 0.0
var _noise: FastNoiseLite
var _noise_time: float = 0.0
var _fly_toggled: bool = false


func _ready() -> void:
	_base_position = position
	_base_offset = offset
	_base_zoom = zoom
	_aim_offset = _base_offset

	_noise = FastNoiseLite.new()
	_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	_noise.frequency = 1.0
	_noise.seed = randi()

	if target == null:
		target = get_parent() as Hero

	if target != null:
		target.aim_started.connect(_on_aim_started)
		target.aim_ended.connect(_on_aim_ended)
		target.shot_fired.connect(_on_shot_fired)

func _exit_tree() -> void:
	if not is_instance_valid(target):
		return
	if target.aim_started.is_connected(_on_aim_started):
		target.aim_started.disconnect(_on_aim_started)
	if target.aim_ended.is_connected(_on_aim_ended):
		target.aim_ended.disconnect(_on_aim_ended)
	if target.shot_fired.is_connected(_on_shot_fired):
		target.shot_fired.disconnect(_on_shot_fired)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fly_camera"):
		_toggle_fly()

	if _fly_toggled:
		_process_fly(delta)
		return

	_update_aim(delta)
	_update_shake(delta)

## Public API for gameplay code that does not go through Hero signals.
func add_trauma(amount: float) -> void:
	_trauma = clampf(_trauma + amount, 0.0, 1.0)

func _on_aim_started() -> void:
	_aiming = true

func _on_aim_ended() -> void:
	_aiming = false

func _on_shot_fired(trauma: float) -> void:
	add_trauma(trauma)
	_zoom_punch = maxf(_zoom_punch, shot_zoom_punch)

func _update_aim(delta: float) -> void:
	var target_blend := 1.0 if _aiming else 0.0
	_aim_blend = move_toward(_aim_blend, target_blend, aim_blend_speed * delta)

	var desired_direction := target.facing_direction() if target != null else 1.0
	_aim_direction = move_toward(_aim_direction, desired_direction, aim_turn_speed * delta)

	var blend := smoothstep(0.0, 1.0, _aim_blend)
	var look_ahead := Vector2(aim_offset.x * _aim_direction, aim_offset.y)
	_aim_offset = _base_offset.lerp(_base_offset + look_ahead, blend)

	_zoom_punch = move_toward(_zoom_punch, 0.0, zoom_punch_decay * delta)
	zoom = _base_zoom.lerp(aim_zoom, blend) + Vector2.ONE * _zoom_punch

func _update_shake(delta: float) -> void:
	_trauma = maxf(_trauma - shake_decay * delta, 0.0)
	var shake := _trauma * _trauma
	_noise_time += delta * shake_noise_speed

	var shake_offset := Vector2(
		_noise.get_noise_2d(_noise_time, 0.0),
		_noise.get_noise_2d(0.0, _noise_time)
	) * shake_max_offset * shake

	offset = _aim_offset + shake_offset
	rotation = _noise.get_noise_2d(_noise_time, 100.0) * shake_max_rotation * shake

func _toggle_fly() -> void:
	_fly_toggled = not _fly_toggled
	if _fly_toggled:
		return
	position = _base_position
	offset = _base_offset
	zoom = _base_zoom
	rotation = 0.0

func _process_fly(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	position += direction * fly_speed * delta
