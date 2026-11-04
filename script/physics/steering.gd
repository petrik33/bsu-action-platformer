class_name Steering extends PhysicsNodeBase

@export var max_acceleration: float = 2000

func seek(target_position: Vector2) -> Vector2:
	var desired_velocity = _get_target_vector(target_position).normalized()
	return (desired_velocity - body.velocity).limit_length(max_acceleration)

func flee(target_position: Vector2) -> Vector2:
	return -seek(target_position)

func arrive(
	target_position: Vector2,
	max_speed: float,
	arrival_radius: float,
	slowing_radius: float,
	time_to_target: float = 0.1
) -> Vector2:
	var to_target = _get_target_vector(target_position)
	var distance = to_target.length()

	if distance < arrival_radius:
		return Vector2.ZERO
		
	var speed_factor := clampf(distance / slowing_radius, 0.0, 1.0)
	var target_speed := max_speed * speed_factor
	
	return velocity_match(to_target.normalized() * target_speed, time_to_target)

func pursue(
	target: Vector2,
	target_velocity: Vector2,
	max_speed: float,
	arrival_radius: float,
	slowing_radius: float,
	max_prediction: float = 0.1
) -> Vector2:
	var direction := _get_target_vector(target)
	var dist := direction.length()
	
	var speed := body.velocity.length()
	var time_to_target := dist / maxf(speed, 0.1)
	var prediction := minf(time_to_target, max_prediction)
	
	var arrive_target := target + target_velocity * prediction
	
	return arrive(arrive_target, max_speed, arrival_radius, slowing_radius, prediction)

func hvelocity_match(target: float, time_to_target: float = 0.1) -> Vector2:
	return velocity_match(Vector2(target, body.velocity.y), time_to_target)
	
func velocity_match(target: Vector2, time_to_target: float = 0.1) -> Vector2:
	var target_acceleration := (target - body.velocity)
	if time_to_target > 0:
		target_acceleration /= time_to_target
	return target_acceleration.limit_length(max_acceleration)

func stop(time_to_target: float = 0.1) -> Vector2:
	return velocity_match(Vector2.ZERO, time_to_target)

func hstop(time_to_target: float = 0.1) -> Vector2:
	return hvelocity_match(0, time_to_target)

func avoid_obstacles(collision_ray: RayCast2D, distance: float) -> Vector2:
	assert(collision_ray.is_colliding())
	return seek(collision_ray.get_collision_point() + collision_ray.get_collision_normal() * distance)


func _get_target_vector(target_position: Vector2) -> Vector2:
	return target_position - body.global_position
