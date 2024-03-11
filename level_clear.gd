extends Area2D


# Called when the node enters the scene tree for the first time.
func _process(_delta):
	var overlapping_pix = get_overlapping_bodies()
	for pix in overlapping_pix:
		if(pix.get_collision_layer_value(6)):
			continue
		pix.get_node("main_sprite").visible = true
		pix.get_node("side_sprites").modulate = Color(1,1,1,1)
		pix.set_collision_layer_value(2, false)
		pix.set_collision_layer_value(1, true)
		pix.set_meta("colour", 1)
	if(!overlapping_pix.is_empty()):
		GameMaster.spawn_next_level()
		queue_free()
