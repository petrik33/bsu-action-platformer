class_name EnemyCharacter extends Actor


@export var state_machine: CharacterStateMachine


func _ready() -> void:
	state_machine.initialize(self)
