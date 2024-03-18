extends Node

@export var levels : Array[PackedScene]
@onready var game_music : AudioStreamPlayer = $"game music"
@onready var menu_music : AudioStreamPlayer = $"menu music"
@onready var game_music_2 : AudioStreamPlayer = $"game music 2"
@onready var game_music_3 : AudioStreamPlayer = $"game music 3"
@onready var level_end_sound : AudioStreamPlayer = $"level end sound"
@onready var pause_menu = $"Pause menu"



const LEVEL_CLEAR = preload("res://level_clear.tscn")
@onready var select_sound = $"select sound"
@onready var hover_sound = $"hover sound"

var white_exit = false
var black_exit = false
var current_level : Node
var current_level_index : int = -1

var is_keyboard
var is_single_player

func _ready():
	menu_music.play()

func start_game():
	current_level_index = 2
	clear_level()

func clear_level():
	if current_level_index > 3 : 
		level_end_sound.play()
	delete_level(current_level)
	BlankLevel.visible = false
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

func _unhandled_input(event):
	if event.is_action_pressed("restart"):
		restart()
	if event.is_action_pressed("Pause"):
		pause()

func restart():
		current_level_index -= 1
		clear_level()
		pause_menu.visible = false
		current_level.process_mode = Node.PROCESS_MODE_INHERIT


func _on_timer_timeout():
	spawn_level(levels[current_level_index + 1])

func open_credits():
	current_level_index += 1
	clear_level()

func open_controls():
	clear_level()

func open_menu():
	current_level_index = -1
	clear_level()
	pause_menu.visible = false
	current_level.process_mode = Node.PROCESS_MODE_INHERIT
	game_music.stop()
	game_music_2.stop()
	game_music_3.stop()
	menu_music.play()
	menu_music.volume_db = -4

func play_hover_sound():
	if !select_sound.playing:
		hover_sound.play()

func toggle_particle_effect(toggle_on):
	BlankLevel.get_node("pixeller").is_animating = toggle_on

func play_select_sound():
	select_sound.play()

func switch_to_game_music_1():
	game_music.volume_db = -80
	game_music.play()
	var tween = get_tree().create_tween()
	tween.tween_property(menu_music, "volume_db", -80, 1)
	tween.parallel().tween_property(game_music, "volume_db", 0, 1)
	tween.tween_callback(menu_music.stop)

func switch_to_game_music_2():
	game_music_2.volume_db = -80
	game_music_2.play()
	var tween = get_tree().create_tween()
	tween.tween_property(game_music, "volume_db", -80, 1)
	tween.parallel().tween_property(game_music_2, "volume_db", 0, 1)
	tween.tween_callback(game_music.stop)
	
func switch_to_game_music_3():
	game_music_3.volume_db = -80
	game_music_3.play()
	var tween = get_tree().create_tween()
	tween.tween_property(game_music_2, "volume_db", -80, 1)
	tween.parallel().tween_property(game_music_3, "volume_db", -8, 1)
	tween.tween_callback(game_music_2.stop)
func pause():
	if not pause_menu.visible and current_level_index > 3 :
		pause_menu.on_visible()
		pause_menu.visible = true
		current_level.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		pause_menu.visible = false
		current_level.process_mode = Node.PROCESS_MODE_INHERIT
