extends Node

@export var levels : Array[PackedScene]

func start_game():
	pass

func next_level():
	pass

func character_at_exit(character : bool):
	if character:
		print("White character entered the exit!")
	else:
		print("Black character entered the exit!")
	pass

func character_left_exit(character : bool):
	if character:
		print("White character exited the exit!")
	else:
		print("Black character exited the exit!")
	pass


func delete_level():
	pass

func spawn_level(level):
	pass
