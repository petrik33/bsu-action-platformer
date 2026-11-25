class_name Gun extends Node

signal aim_started
signal aim_ended
signal shot_fired(trauma: float)
signal reload_started
signal reload_cancelled
signal reload_finished
signal holstered
signal bullet_added(count: int)

@export var shooter: Actor
@export var clip_size: int = 3
@export var bullet_scene: PackedScene
@export var bullet_speed: float = 900
@export var bullet_origin: Node2D
@export var bullet_next_origin: Node2D
@export_range(0.0, 1.0) var shot_trauma: float = 0.5

var bullets_in_clip: int = 0
var is_holstered: bool = true
var is_reloading: bool = false


func _ready() -> void:
	if shooter == null:
		shooter = get_parent() as Actor
	bullets_in_clip = clip_size

func aim() -> void:
	aim_started.emit()

func stop_aim() -> void:
	aim_ended.emit()

func draw() -> void:
	is_holstered = false

func holster() -> void:
	is_holstered = true
	holstered.emit()

func is_clip_empty() -> bool:
	return bullets_in_clip <= 0

func is_loaded() -> bool:
	return not is_clip_empty()

func can_shoot() -> bool:
	return is_loaded()

func fire() -> bool:
	if not can_shoot():
		return false
	bullets_in_clip -= 1
	if bullet_scene != null:
		var from := bullet_origin.global_position if bullet_origin != null else shooter.global_position
		var direction := Vector2.RIGHT * shooter.facing_direction()
		var bullet := Projectiles.spawn(bullet_scene, from, direction, shooter, bullet_speed)
		if bullet != null and bullet_next_origin != null:
			bullet.move_to(bullet_next_origin.global_position)
	shot_fired.emit(shot_trauma)
	return true

func can_reload() -> bool:
	return bullets_in_clip < clip_size

func reload() -> void:
	if is_reloading:
		return
	is_reloading = true
	reload_started.emit()

func cancel_reload() -> void:
	if not is_reloading:
		return
	is_reloading = false
	reload_cancelled.emit()

func add_bullet() -> bool:
	if bullets_in_clip >= clip_size:
		return false
	bullets_in_clip += 1
	bullet_added.emit(bullets_in_clip)
	return true

func finish_reload() -> void:
	if not is_reloading:
		return
	while bullets_in_clip < clip_size:
		add_bullet()
	is_reloading = false
	reload_finished.emit()
