class_name Steering extends PhysicsNodeBase

<<<<<<< HEAD
@export var max_speed: float = 400
@export var max_acceleration: float = 2000
@export var deceleration: float = 2000
@export var horizontal_only: bool = true

var body: CharacterBody2D
var force: Vector2 = Vector2.ZERO
=======
@export var max_acceleration: float = 2000

func seek(target_position: Vector2) -> Vector2:
	var desired_velocity = _get_target_vector(target_position).normalized()
	return (desired_velocity - body.velocity).limit_length(max_acceleration)
>>>>>>> 6dbdf0c643db47ca6ae3954808939a48006d9b4f

func flee(target_position: Vector2) -> Vector2:
	return -seek(target_position)

<<<<<<< HEAD
func _ready():
	body = get_parent() as CharacterBody2D
	if not body:
		push_error("Steering component must be a child of CharacterBody2D")

func _get_configuration_warnings():
	if not get_parent() is CharacterBody2D:
		return ["Steering component must be a child of CharacterBody2D"]
	return []


func update(applied_force: Vector2):
	force = applied_force

func apply(delta: float):
	if horizontal_only:
		force.y = 0
	body.velocity += force * delta
	body.velocity = body.velocity.limit_length(max_speed)
	force = Vector2.ZERO

?func seek(target_position: Vector2, acceleration := -1.0) -> Vector2:
	if acceleration < 0:
		acceleration = max_acceleration
	return (target_position - body.global_position).normalized() * acceleration

func arrive(
	target_position: Vector2,
	target_radius: float = 4.0,
	slowing_radius: float = 40.0,
	time_to_target: float = 0.1,
	acceleration: float = -1.0
) -> Vector2:
	var to_target = target_position - body.global_position
	var distance = to_target.length()

	if distance < target_radius:
		return Vector2.ZERO

	var target_speed := max_speed
	if distance <= slowing_radius:
		target_speed *= distance / slowing_radius
	
	var target_velocity := to_target.normalized() * target_speed
	var output := target_velocity - body.velocity
	output /= time_to_target
	
	if acceleration < 0:
		acceleration = max_acceleration
	
	output = output.limit_length(acceleration)
	
	return output

func velocity_match(target: Vector2,
	time_to_target: float = 0.1,
	acceleration: float = -1.0
) -> Vector2:
	var output := target - body.velocity
	output /= time_to_target
	
	if acceleration < 0:
		acceleration = max_acceleration
		
	output = output.limit_length(acceleration)
	return output

func stop() -> Vector2:
	return velocity_match(Vector2.ZERO, 0.1, deceleration)

func dash(velocity: Vector2) -> Vector2:
	return velocity - body.velocity
=======
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
>>>>>>> 6dbdf0c643db47ca6ae3954808939a48006d9b4f
