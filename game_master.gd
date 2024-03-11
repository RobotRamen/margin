extends Node

@export var levels : Array[PackedScene]
@onready var game_music : AudioStreamPlayer = $"game music"
@onready var menu_music : AudioStreamPlayer = $"menu music"
const LEVEL_CLEAR = preload("res://level_clear.tscn")

var white_exit = false
var black_exit = false
var current_level : Node
var current_level_index : int = -1

func _ready():
	menu_music.play()

func start_game():
	game_music.play()
	game_music.volume_db = -20
	var tween = get_tree().create_tween()
	tween.tween_property(menu_music, "volume_db", -20, 1)
	tween.tween_property(game_music, "volume_db", 0, 1)
	tween.tween_callback(game_music.stop)
	spawn_level(levels[current_level_index + 1])

func clear_level():
	delete_level(current_level)
	spawn_clear()

func character_at_exit(character : bool):
	if character:
		white_exit = true
	else:
		black_exit = true
	pass
	if white_exit and black_exit:
		clear_level()

func character_left_exit(character : bool):
	if character:
		white_exit = false
	else:
		black_exit = false
	pass


func delete_level(level : Node):
	level.queue_free()

func spawn_next_level():
	spawn_level(levels[current_level_index + 1])

func spawn_level(level : PackedScene):
	var new_level = level.instantiate()
	add_sibling(new_level)
	current_level = new_level
	current_level_index += 1

func spawn_clear():
	add_sibling(LEVEL_CLEAR.instantiate())
