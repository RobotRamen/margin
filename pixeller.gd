extends Node2D

@onready var pixel = preload("res://pixel.tscn")
@onready var white_character = $"../whiteCharacter"
@onready var black_character = $"../BlackCharacter"

var pixel_density = 6

# The thread will start here.
func _ready():
	for i in 1740/pixel_density:
		for j in 900/pixel_density:
			if (i+j)%2:
				var new_pixel : Node2D = pixel.instantiate()
				add_child(new_pixel)
				new_pixel.position = Vector2(i*pixel_density+pixel_density/2.0,j*pixel_density+pixel_density/2.0)
				for side_sprite in new_pixel.get_node("side_sprites").get_children():
						side_sprite.position += Vector2(randf_range(-30., +30.),randf_range(-30., +30.))
						side_sprite.scale *= randf_range(0.4, 1.3)
				new_pixel.rotate(deg_to_rad(randf_range(0., 360.)))
	white_character.process_mode = Node.PROCESS_MODE_INHERIT
	black_character.process_mode = Node.PROCESS_MODE_INHERIT
