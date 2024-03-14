extends CanvasLayer
@onready var start_button = $"Node2D/start button"

func _ready():
	start_button.grab_focus()

func _on_start_button_pressed():
	GameMaster.start_game()
	visible = false


func _on_controls_button_pressed():
	GameMaster.open_controls()


func _on_credits_button_pressed():
	GameMaster.open_credits()


func _on_exit_button_pressed():
	get_tree().quit()
