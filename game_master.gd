extends Node

@export var levels : Array[PackedScene]
@onready var game_music : AudioStreamPlayer = $"game music"
@onready var menu_music : AudioStreamPlayer = $"menu music"

func _ready():
	menu_music.play()

func start_game():
	game_music.play()
	game_music.volume_db = -20
	var tween = get_tree().create_tween()
	tween.tween_property(menu_music, "volume_db", -20, 1)
	tween.tween_property(game_music, "volume_db", 0, 1)
	tween.tween_callback(game_music.stop)

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
