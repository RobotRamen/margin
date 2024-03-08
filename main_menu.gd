extends CanvasLayer

func _on_start_button_pressed():
	pass # Replace with function body.


func _on_controls_button_pressed():
	$Controls.visible = true
	$VBoxContainer.visible = false


func _on_credits_button_pressed():
	$VBoxContainer.visible = false
	$Credits.visible = true



func _on_exit_button_pressed():
	get_tree().quit()


func _on_back_button_pressed():
	$Credits.visible = false
	$Controls.visible = false
	$VBoxContainer.visible = true
