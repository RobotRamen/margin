extends Area2D

signal cleared

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	var overlapping_pix = get_overlapping_bodies()
	for pix in overlapping_pix:
		pix.get_node("main_sprite").visible = false
		pix.get_node("side_sprites").modulate = Color(0,0,0,1)
		pix.set_collision_layer_value(1, false)
		pix.set_collision_layer_value(2, true)
		pix.set_meta("colour", 2)
	if(!overlapping_pix.is_empty()):
		cleared.emit()
		queue_free()
