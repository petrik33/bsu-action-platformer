class_name HeroStateBase extends CharacterStateBase


var hero: Hero:
	get():
		return character as Hero

var steering: Steering:
	get():
		return hero.steering


func init(character_owner: CharacterBody2D):
	super.init(character_owner)
	assert(hero != null, "Can't use GameCharacterState in non-character FSM")
