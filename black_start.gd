extends Area2D


# Called when the node enters the scene tree for the first time.
func _process(_delta):
	var overlapping_pix = get_overlapping_bodies()
	for pix in overlapping_pix:
		pix.visible = false
		pix.set_collision_layer_value(1, false)
		pix.set_collision_layer_value(2, true)
	if(!overlapping_pix.is_empty()):
		queue_free()
