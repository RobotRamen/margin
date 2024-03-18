extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_main_menu_button_pressed():
	GameMaster.open_menu()


func _on_restart_button_pressed():
	GameMaster.restart()

func on_visible():
	$"VBoxContainer/Restart button".grab_focus()
