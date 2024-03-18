extends CanvasLayer

func _ready():
	$"Node2D/1P+K button".grab_focus()

func _on_pk_button_pressed():
	GameMaster.play_select_sound()
	GameMaster.is_keyboard = true
	GameMaster.is_single_player = true
	GameMaster.clear_level()


func _on_pc_button_pressed():
	GameMaster.play_select_sound()
	GameMaster.is_keyboard = false
	GameMaster.is_single_player = true
	GameMaster.clear_level()



func _on_2pk_button_pressed():
	GameMaster.play_select_sound()
	GameMaster.is_keyboard = true
	GameMaster.is_single_player = false
	GameMaster.clear_level()


func _on_2pc_button_pressed():
	GameMaster.play_select_sound()
	GameMaster.is_keyboard = false
	GameMaster.is_single_player = false
	GameMaster.clear_level()

