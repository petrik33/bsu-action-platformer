class_name EnemyNavigtionGrounded extends EnemyNavigationBsae


@export var wall_check: RayCast2D
@export var floor_check: RayCast2D


func force_update():
	wall_check.force_raycast_update()
	floor_check.force_raycast_update()


func has_obstacles_ahead() -> bool:
	var wall_ahead = wall_check.is_colliding()
	var no_floor_ahead = not floor_check.is_colliding()
	return wall_ahead or no_floor_ahead 
