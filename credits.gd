extends Control

func _ready():
	$"back button".grab_focus()

func _on_back_button_pressed():
	GameMaster.play_select_sound()
	GameMaster.open_menu()
