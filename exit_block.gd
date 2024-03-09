extends Area2D

# White is true, Black is false
@export var exit_colour : bool = true

func _on_body_entered(body):
	GameMaster.character_at_exit(exit_colour)

func _on_body_exited(body):
	GameMaster.character_left_exit(exit_colour)
