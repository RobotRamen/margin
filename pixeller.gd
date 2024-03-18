extends Node2D

@onready var pixel = preload("res://pixel.tscn")

var pixel_density = 10

var is_animating = false

# The thread will start here.
func _ready():
	for i in 1820/pixel_density:
		for j in 980/pixel_density:
			if (i+j)%2:
				var new_pixel : Node2D = pixel.instantiate()
				add_child(new_pixel)
				new_pixel.position = Vector2(i*pixel_density+pixel_density/2.0 + 50,j*pixel_density+pixel_density/2.0 + 50)
				for side_sprite : CanvasItem in new_pixel.get_node("side_sprites").get_children():
						side_sprite.position += Vector2(randf_range(-10., +10.),randf_range(-10., +10.))
						side_sprite.rotation = randf_range(0, 4)
						side_sprite.scale *= randf_range(.5, 3.5)
						side_sprite.z_index = randi_range(-1,1)
				new_pixel.rotate(deg_to_rad(randf_range(0., 360.)))
				new_pixel.set_meta("colour", 1)


func _on_timer_timeout():
	if is_animating:
		for pix in get_children():
			if pix is Node2D:
				pix.rotation += 0.05
