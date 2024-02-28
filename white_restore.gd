extends Area2D

@onready var white_character = $"../whiteCharacter"
const final_speed = 1000
var speed = 1
var direction
func _ready():
	var initial_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	direction = initial_direction

func _physics_process(delta):
	var direction_to_character : Vector2 = (white_character.position + Vector2(0,-50)) - position
	direction_to_character = direction_to_character.normalized()
	direction = ((direction_to_character + direction*3)/4).normalized()
	speed = (speed*4 + final_speed)/5
	position += direction * delta * speed
	
	if get_overlapping_bodies():
		white_character.on_restore_pickup()
		queue_free()