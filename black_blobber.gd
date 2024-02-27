extends Area2D


func _ready():
	$CollisionShape2D.shape.radius = 1.0
	var tween = get_tree().create_tween()
	tween.tween_property($CollisionShape2D.shape, "radius", 50, 0.3)
	tween.tween_callback(queue_free)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var overlapping_pix = get_overlapping_bodies()
	for pix in overlapping_pix:
		pix.visible = false
		pix.set_collision_layer_value(2, true)
		pix.set_collision_layer_value(1, false)

