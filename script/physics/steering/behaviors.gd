class_name SteeringBehaviors

static func pursue(target: CharacterBody2D, speed: float) -> Pursue:
	var bhv := Pursue.new()
	bhv.target_position = target.global_position
	bhv.target_velocity = target.velocity
	bhv.max_speed = speed
	return bhv

static func arrive(at: Vector2) -> Arrive:
	var bhv := Arrive.new()
	bhv.target_position = at
	return bhv

static func hvelocity_match(to: float) -> HorizontalVelocityMatch:
	var bhv := HorizontalVelocityMatch.new()
	bhv.velocity = to
	return bhv

static func velocity_match(to: Vector2) -> VelocityMatch:
	var bhv := VelocityMatch.new()
	bhv.velocity = to
	return bhv

static func hstop() -> HorizontalVelocityMatch:
	return hvelocity_match(0.0)

static func stop() -> VelocityMatch:
	return velocity_match(Vector2.ZERO)

static func flee(from: Vector2, speed: float) -> Flee:
	var bhv := Flee.new()
	bhv.target_position = from
	bhv.speed = speed
	return bhv

static func seek(at: Vector2, speed: float) -> Seek:
	var bhv := Seek.new()
	bhv.target_position = at
	bhv.speed = speed
	return bhv
