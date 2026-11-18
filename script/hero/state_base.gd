class_name HeroStateBase extends CharacterStateBase


var hero: Hero:
	get():
		return character as Hero

var steering: Steering:
	get():
		return hero.steering

var kinematic: KinematicBase:
	get():
		return hero.kinematic


func init(character_owner: CharacterBody2D, owner_machine: CharacterStateMachine):
	super.init(character_owner, owner_machine)
	assert(hero != null, "Can't use GameCharacterState in non-character FSM")
