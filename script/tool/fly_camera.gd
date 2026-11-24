class_name FlyCamera extends Camera2D

## Debug free-fly camera.
##
## Ships disabled next to the gameplay [CameraRig] and only takes over the
## viewport while toggled on with the "fly_camera" action (tilde key). It owns
## no gameplay behaviour: disabling it hands the viewport back to whichever
## camera was current before activation.
##
## Controls:
## - left/right/up/down: pan
## - sprint: pan faster
## - mouse wheel: zoom

@export_group("Movement")
@export var fly_speed: float = 600.0
@export var sprint_multiplier: float = 3.0

@export_group("Zoom")
@export var zoom_step: float = 0.1
@export var zoom_min: float = 0.25
@export var zoom_max: float = 8.0

var _active: bool = false
var _previous_camera: Camera2D


func _ready() -> void:
	enabled = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fly_camera"):
		if _active:
			_deactivate()
		else:
			_activate()

	if not _active:
		return

	var direction := Input.get_vector("left", "right", "up", "down")
	var speed := fly_speed
	if Input.is_action_pressed("sprint"):
		speed *= sprint_multiplier
	position += direction * speed * delta

func _unhandled_input(event: InputEvent) -> void:
	if not _active:
		return
	if not (event is InputEventMouseButton and event.pressed):
		return

	match event.button_index:
		MOUSE_BUTTON_WHEEL_UP:
			_set_zoom(zoom.x + zoom_step)
		MOUSE_BUTTON_WHEEL_DOWN:
			_set_zoom(zoom.x - zoom_step)
		_:
			return
	get_viewport().set_input_as_handled()

func _activate() -> void:
	_previous_camera = get_viewport().get_camera_2d()
	if _previous_camera == self:
		_previous_camera = null

	# Start from the current game view so the switch is not disorienting.
	if _previous_camera != null:
		global_position = _previous_camera.global_position
		zoom = _previous_camera.zoom

	enabled = true
	make_current()
	_active = true

func _deactivate() -> void:
	_active = false
	enabled = false

	if is_instance_valid(_previous_camera) and _previous_camera.is_inside_tree():
		_previous_camera.enabled = true
		_previous_camera.make_current()
	_previous_camera = null

func _set_zoom(value: float) -> void:
	var clamped := clampf(value, zoom_min, zoom_max)
	zoom = Vector2.ONE * clamped
