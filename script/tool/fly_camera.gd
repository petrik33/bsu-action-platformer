extends Camera2D

@export var speed: float = 600.0
@export var toggled: bool = false

var og_position: Vector2

func _ready() -> void:
	og_position = position

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fly_camera"):
		toggled = not toggled
	if not toggled:
		position = og_position
		return
	var direction := Input.get_vector("left", "right", "up", "down")
	position += direction * speed * delta
