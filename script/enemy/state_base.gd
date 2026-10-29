class_name EnemyStateBase extends CharacterStateBase


var enemy: Enemy:
	get():
		return character as Enemy

var perception: EnemyPerception:
	get():
		return enemy.perception

var navigation: EnemyNavigationBsae:
	get():
		return enemy.navigation

var steering: Steering:
	get():
		return enemy.steering


func init(character_owner: CharacterBody2D):
	super.init(character_owner)
	assert(enemy != null, "Can't use EnemyState in non-enemy FSM")
