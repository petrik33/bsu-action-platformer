extends Node

## Debug-only service hub.
##
## Registered as an autoload so it exists before any gameplay scene, but it
## stays inert in exported release builds. In debug it spawns the FlyCamera
## overlay into the current scene root and re-spawns it on every scene change,
## which keeps debug nodes out of the shipped scene files entirely.

const FLY_CAMERA_SCENE := preload("res://scene/tool/fly_camera.tscn")

var _fly_camera: FlyCamera


func _ready() -> void:
	if not is_active():
		return

	get_tree().scene_changed.connect(_attach_fly_camera)
	# Autoloads are ready before the initial scene exists; scene_changed covers
	# later loads, this covers the first one.
	await get_tree().process_frame
	_attach_fly_camera()

## True when debug tooling should be running (editor and debug exports).
func is_active() -> bool:
	return OS.is_debug_build()

## The spawned debug camera, or null when debug tooling is off.
func get_fly_camera() -> FlyCamera:
	return _fly_camera if is_instance_valid(_fly_camera) else null

func _attach_fly_camera() -> void:
	var scene := get_tree().current_scene
	if scene == null:
		return

	# A scene may already author its own fly camera; never stack two.
	for child in scene.get_children():
		if child is FlyCamera:
			_fly_camera = child
			return

	_fly_camera = FLY_CAMERA_SCENE.instantiate()
	scene.add_child(_fly_camera)
