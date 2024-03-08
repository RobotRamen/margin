extends Area2D

# White is true, Black is false
@export var exit_colour : bool = true
var game_master

func _ready():
	game_master = get_node("/root/GameMaster")

func _on_body_entered(body):
	game_master.character_at_exit(exit_colour)

