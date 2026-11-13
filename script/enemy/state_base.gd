class_name EnemyStateBase extends CharacterStateBase


var enemy: Enemy:
	get():
		return character as Enemy

var perception: EnemyPerception:
	get():
		return enemy.perception

var navigation: NavigationBase:
	get():
		return enemy.navigation

var steering: Steering:
	get():
		return enemy.steering

var kinematic: KinematicBase:
	get():
		return enemy.kinematic

var attack: EnemyAttack:
	get():
		return enemy.attack

var patroling: Patroling:
	get():
		return enemy.patroling


func init(character_owner: CharacterBody2D):
	super.init(character_owner)
	assert(enemy != null, "Can't use EnemyState in non-enemy FSM")
