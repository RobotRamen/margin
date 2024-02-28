extends Area2D

@onready var white_character = $"../whiteCharacter"
const speed = 1500

func _physics_process(delta):
	var direction_to_character : Vector2 = (white_character.position + Vector2(0,-50)) - position
	direction_to_character = direction_to_character.normalized()
	position += direction_to_character * delta * speed
	
	if get_overlapping_bodies():
		white_character.on_restore_pickup()
		queue_free()
