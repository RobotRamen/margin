extends CanvasLayer
@onready var start_button = $"Node2D/start button"

func _ready():
	start_button.grab_focus()

func _on_start_button_pressed():
	GameMaster.play_select_sound()
	GameMaster.start_game()
	visible = false


func _on_controls_button_pressed():
	GameMaster.play_select_sound()
	GameMaster.open_controls()


func _on_credits_button_pressed():
	GameMaster.play_select_sound()
	GameMaster.open_credits()


func _on_exit_button_pressed():
	GameMaster.play_select_sound()
	get_tree().quit()


func _on_check_button_toggled(toggled_on):
	GameMaster.toggle_particle_effect(toggled_on)
