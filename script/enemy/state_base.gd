class_name EnemyCharacterStateBase extends CharacterStateBase


var enemy:
	get():
		return character as EnemyCharacter


func init(character_owner: CharacterBody2D):
	super.init(character_owner)
	assert(enemy != null, "Can't use EnemyCharacterState in non-enemy FSM")
