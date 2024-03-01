extends Area2D

@onready var black_character = $"../blackCharacter"

func _ready():
	$CollisionShape2D.shape.radius = 1.0
	var tween = get_tree().create_tween()
	tween.tween_property($CollisionShape2D.shape, "radius", 50, 0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(queue_free)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var overlapping_pix = get_overlapping_bodies()
	for pix in overlapping_pix:
		#pix.get_node("main_sprite").visible = false
		pix.get_node("side_sprites").modulate = Color(0,0,0,1)
		pix.set_collision_layer_value(2, true)
		pix.set_collision_layer_value(1, false)
		black_character.add_pixel(pix)
