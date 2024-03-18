extends Button

func _on_mouse_entered():
	grab_focus()


func _on_focus_entered():
	GameMaster.play_hover_sound()
