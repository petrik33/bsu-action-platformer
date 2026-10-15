class_name GameCharacterStateBase extends CharacterStateBase


var game_character:
	get():
		return character as GameCharacter


func init(character_owner: CharacterBody2D):
	super.init(character_owner)
	assert(game_character != null, "Can't use GameCharacterState in non-character FSM")
