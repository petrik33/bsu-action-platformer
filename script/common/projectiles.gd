extends Node

## Global projectile spawner. Register as an autoload named "Projectiles".
##
## Projectiles are parented to the node in the "projectiles" group. If the
## current scene has no such node, a container is created under the scene root.

const CONTAINER_GROUP := &"projectiles"


func spawn(scene: PackedScene, from: Vector2, direction: Vector2, shooter: Node2D, speed: float) -> Projectile:
	if scene == null:
		push_error("Projectiles.spawn: scene is null.")
		return null

	var bullet := scene.instantiate() as Projectile
	if bullet == null:
		push_error("Projectiles.spawn: scene root is not a Projectile.")
		return null

	var container := _get_container()
	if container == null:
		bullet.free()
		return null

	container.add_child(bullet)
	bullet.shoot(from, direction, shooter, speed)
	return bullet


func _get_container() -> Node2D:
	var container := get_tree().get_first_node_in_group(CONTAINER_GROUP) as Node2D
	if container != null:
		return container

	var scene := get_tree().current_scene
	if scene == null:
		push_error("Projectiles.spawn: no current scene and no container.")
		return null

	container = Node2D.new()
	container.name = "Projectiles"
	container.z_index = 1
	container.add_to_group(CONTAINER_GROUP)
	scene.add_child(container)
	return container
