extends Area2D

@onready var white_character = $"../whiteCharacter"

func _ready():
	$CollisionShape2D.shape.radius = 1.0
	var tween = get_tree().create_tween()
	tween.tween_property($CollisionShape2D.shape, "radius", 50, 0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(queue_free)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var overlapping_pix = get_overlapping_bodies()
	for pix in overlapping_pix:
		#pix.get_node("main_sprite").visible = true
		pix.get_node("side_sprites").modulate = Color(1,1,1,1)
		pix.set_collision_layer_value(1, true)
		pix.set_collision_layer_value(2, false)
		white_character.add_pixel(pix)
